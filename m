Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbYARVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbYARVsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764991AbYARVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:48:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764219AbYARVs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:48:28 -0500
Date: Fri, 18 Jan 2008 22:47:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes for v2.6.24
Message-ID: <20080118214749.GA13058@elte.hu>
References: <20080118154809.GA18248@elte.hu> <20080118191249.GA20384@uranus.ravnborg.org> <20080118205152.GF3079@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118205152.GF3079@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > >  # Directories & files removed with 'make mrproper'
> > > -MRPROPER_DIRS  += include/config include2 usr/include
> > > +MRPROPER_DIRS  += include/config include2 usr/include arch/i386 arch/x86_64
> > sigh - arch specific stuff in the top-level Makefile.
> > This really belongs in arch/x86/Makefile
> 
> is this a NACK? Can clean this up in v2.6.25, but this seemed the only 
> simple solution for v2.6.24.

ok, since it's admittedly ugly, and all we have in arch/i386/kernel/boot 
is a symbolic link, i've removed that commit from the .24 updates 
portion of x86.git.

Linus, could you please pull this single fix instead:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Arjan van de Ven (1):
      x86: add support for the latest Intel processors to Oprofile

 nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2d0eeac..944bbcd 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -380,7 +380,7 @@ static int __init ppro_init(char ** cpu_type)
 
 	if (cpu_model == 14)
 		*cpu_type = "i386/core";
-	else if (cpu_model == 15)
+	else if (cpu_model == 15 || cpu_model == 23)
 		*cpu_type = "i386/core_2";
 	else if (cpu_model > 0xd)
 		return 0;
