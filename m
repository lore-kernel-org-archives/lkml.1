Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYAAPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYAAPL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYAAPLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:11:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:23592 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYAAPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XASBwJ4Xs5RT3pfxKt8bh6BAH8eu7CE28kz/72QFSzFiN6BL5WiBJVNIZg0oOVhAy7aDDR0l75sTI1Huh58aSJZuJRkhLAM/9f7iXB3FR/dqPLbOon5HrcJIRyqGga04qvS3OfF/I9jpW93DOpTxWyitcRjf6QAVfZ+tLMNGnis=
Date: Tue, 1 Jan 2008 18:11:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] get rid of checkpatch.pl complains on apm_32.c
Message-ID: <20080101151112.GC7937@cvg.cvg>
References: <20071231204753.GA7411@cvg.cvg> <20080101150054.GB4434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101150054.GB4434@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Jan 01, 2008 at 04:00:54PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > This patch eliminates most of code-style errors discovered by 
| > checkpatch.pl on arch/x86/kernel/apm_32.c
| 
| looks good in principle, but the patch is not a NOP:
| 
|     text    data     bss     dec     hex filename
|    12142    1837      84   14063    36ef apm_32.o.before
|    12141    1837      84   14062    36ee apm_32.o.after
|  md5:
|  2676b881ad55e387da4a995e8b9ee372  apm_32.o.before.asm
|  7fcce83dca90ded66cc43f9b4d4ca2d2  apm_32.o.after.asm
| 
| cleanup patches should not change the resulting object code. The change 
| is due to this hunk:
| 
| @@ -1918,8 +1940,9 @@ static int __init apm_is_horked_d850md(c
|  {
|  	if (apm_info.disabled == 0) {
|  		apm_info.disabled = 1;
| -		printk(KERN_INFO "%s machine detected. Disabling APM.\n", d->ident);
| -		printk(KERN_INFO "This bug is fixed in bios P15 which is available for \n");
| +		printk(KERN_INFO "%s machine detected. "
| +		       "Disabling APM.\n", d->ident);
| +		printk(KERN_INFO "This bug is fixed in bios P15 which is available for\n");
|  		printk(KERN_INFO "download from support.intel.com \n");
|  	}
|  	return 0;
| 
| the "for \n" has been changed to "for\n". Which is an OK cleanup, but 
| please do such material changes in separate patches in the future. (we 
| can accept and review cleanup patches that are NOPs much easier and 
| faster)
| 
| so i removed that string change and applied your patch to x86.git, which 
| is now a nice NOP:
| 
|     text    data     bss     dec     hex filename
|    12142    1837      84   14063    36ef apm_32.o.before
|    12142    1837      84   14063    36ef apm_32.o.after
| 
|  md5:
| 
|    2676b881ad55e387da4a995e8b9ee372  apm_32.o.before.asm
|    2676b881ad55e387da4a995e8b9ee372  apm_32.o.after.asm
| 
| 	Ingo
|

damn me! *really* sorry for this.
Ingo, do you use some script for this checking? if yes - could you share it? ;)
(i think it's not really hard to write myown, but your one is really preferred
;)

		- Cyrill -
