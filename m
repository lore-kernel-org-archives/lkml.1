Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbYD2T0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbYD2T0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYD2T01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:26:27 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:49762 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760027AbYD2T0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:26:25 -0400
X-Greylist: delayed 1902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 15:26:25 EDT
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 11/19] UML - Track and make up lost ticks
References: <20080425175613.GA11192@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: because extension languages should come with the editor built in.
Date: Tue, 29 Apr 2008 19:54:02 +0100
In-Reply-To: <20080425175613.GA11192@c2.user-mode-linux.org> (Jeff Dike's message of "Fri, 25 Apr 2008 13:56:13 -0400")
Message-ID: <877iegcx11.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8BIT
X-DCC-dcc.uncw.edu-Metrics: hades 1201; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Apr 2008, Jeff Dike stated, in part:
> Index: linux-2.6-git/arch/um/os-Linux/time.c
> ===================================================================
> --- linux-2.6-git.orig/arch/um/os-Linux/time.c	2008-04-25 10:42:12.000000000 -0400
> +++ linux-2.6-git/arch/um/os-Linux/time.c	2008-04-25 11:19:26.000000000 -0400
> +	alarm_handler(SIGVTALRM, NULL);
> +		alarm_handler(SIGVTALRM, NULL);
> -extern void alarm_handler(int sig, struct sigcontext *sc);
> -		alarm_handler(SIGVTALRM, NULL);

Yet, in arch/um/include/process.h, we see, unchanged since the year dot, the
obviously wrong prototype:

extern void alarm_handler(int sig, struct sigcontext sc);

Hence:

  CC      arch/um/os-Linux/time.o
arch/um/os-Linux/time.c: In function ¡deliver_alarm¢:
arch/um/os-Linux/time.c:119: error: incompatible type for argument 2 of ¡alarm_handler¢
make[1]: *** [arch/um/os-Linux/time.o] Error 1
make: *** [arch/um/os-Linux] Error 2

Fix trivial:

Signed-off-by: Nick Alcock <nix@esperi.org.uk>
-- 
Index: linux/arch/um/include/process.h
===================================================================
--- linux.orig/arch/um/include/process.h	2006-07-09 14:19:52.000000000 +0100
+++ linux/arch/um/include/process.h	2008-04-29 19:49:49.000000000 +0100
@@ -8,8 +8,8 @@
 
 #include <signal.h>
 
-extern void sig_handler(int sig, struct sigcontext sc);
-extern void alarm_handler(int sig, struct sigcontext sc);
+extern void sig_handler(int sig, struct sigcontext *sc);
+extern void alarm_handler(int sig, struct sigcontext *sc);
 
 #endif
 
