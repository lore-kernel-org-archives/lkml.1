Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbYASOIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbYASOIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYASOIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:08:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYASOI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:08:29 -0500
Date: Sat, 19 Jan 2008 15:08:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: remove casts
Message-ID: <20080119140817.GA4405@elte.hu>
References: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr> <20080118104553.GB8785@elte.hu> <Pine.LNX.4.64.0801191455180.27831@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801191455180.27831@fbirervta.pbzchgretzou.qr>
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


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> On Jan 18 2008 11:45, Ingo Molnar wrote:
> >* Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> >> This is against x86/mm.
> >
> >hm, it has checkpatch failures -
> 
> All false positives.

no, not "All false positives", the first checkpatch failure is a blatant 
ugliness that you introduced:

 ERROR: use tabs not spaces
 #137: FILE: arch/x86/kernel/microcode.c:248:
 +^I^I          EXT_SIGNATURE_SIZE * i;$

because you converted a tab to a sequence of 10 spaces:

-		ext_sig = (struct extended_signature *)((void *)ext_header
-			+ EXT_HEADER_SIZE + EXT_SIGNATURE_SIZE * i);
+		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
+		          EXT_SIGNATURE_SIZE * i;
                <........>

(the second checkpatch warning is a false positive.)

and i applied your patch before i notified you, but apparently you 
couldnt be bothered to check. Please do not bother to send patches with 
such an attitude, it's just a waste of people's time.

	Ingo
