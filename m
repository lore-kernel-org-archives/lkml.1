Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYAAPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYAAPBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYAAPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:01:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYAAPBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:01:11 -0500
Date: Tue, 1 Jan 2008 16:00:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] get rid of checkpatch.pl complains on apm_32.c
Message-ID: <20080101150054.GB4434@elte.hu>
References: <20071231204753.GA7411@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231204753.GA7411@cvg.cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch eliminates most of code-style errors discovered by 
> checkpatch.pl on arch/x86/kernel/apm_32.c

looks good in principle, but the patch is not a NOP:

    text    data     bss     dec     hex filename
   12142    1837      84   14063    36ef apm_32.o.before
   12141    1837      84   14062    36ee apm_32.o.after
 md5:
 2676b881ad55e387da4a995e8b9ee372  apm_32.o.before.asm
 7fcce83dca90ded66cc43f9b4d4ca2d2  apm_32.o.after.asm

cleanup patches should not change the resulting object code. The change 
is due to this hunk:

@@ -1918,8 +1940,9 @@ static int __init apm_is_horked_d850md(c
 {
 	if (apm_info.disabled == 0) {
 		apm_info.disabled = 1;
-		printk(KERN_INFO "%s machine detected. Disabling APM.\n", d->ident);
-		printk(KERN_INFO "This bug is fixed in bios P15 which is available for \n");
+		printk(KERN_INFO "%s machine detected. "
+		       "Disabling APM.\n", d->ident);
+		printk(KERN_INFO "This bug is fixed in bios P15 which is available for\n");
 		printk(KERN_INFO "download from support.intel.com \n");
 	}
 	return 0;

the "for \n" has been changed to "for\n". Which is an OK cleanup, but 
please do such material changes in separate patches in the future. (we 
can accept and review cleanup patches that are NOPs much easier and 
faster)

so i removed that string change and applied your patch to x86.git, which 
is now a nice NOP:

    text    data     bss     dec     hex filename
   12142    1837      84   14063    36ef apm_32.o.before
   12142    1837      84   14063    36ef apm_32.o.after

 md5:

   2676b881ad55e387da4a995e8b9ee372  apm_32.o.before.asm
   2676b881ad55e387da4a995e8b9ee372  apm_32.o.after.asm

	Ingo
