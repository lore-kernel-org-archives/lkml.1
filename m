Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbXCHMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbXCHMSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 07:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXCHMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 07:18:54 -0500
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:34015 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751553AbXCHMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 07:18:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=Iyfzqi7rBWI/p3ADas/1H/VEDmdXRrOhBe8ElKpQWsRAmVcvqYajlN/7luefsVHw82G/3hBT/eo6K6JJtSL/PpQ3tISU9H6ZvAA8KedEJ9mGGkz+qCr/JfTdACXq9awP3Tfxc2FXIxRs71EGLFgwzt8VY211il3LScpGK+eV9ww=  ;
X-YMail-OSG: 325M20UVM1leKOhkfYcv5vk1WgkrEzDSawMUT2hwjsp_lYWGTczBe_ElShWKkwbFISEXNIqunEGwcGdfhvbVOXfpZqDIPhG7zueh60ZPcU2xD3cdZHA5dIQEXRqYcJnqJgImBpR0qEhdC_mRA2pmrZ15al_cyM0jyCgiVphfsJ8tC4NKO28z6soZOVWk
From: Blaisorblade <blaisorblade@yahoo.it>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 027/101] Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled.
Date: Thu, 8 Mar 2007 13:17:36 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20070307171035.150802805@mini.kroah.org> <20070307171247.038163039@mini.kroah.org>
In-Reply-To: <20070307171247.038163039@mini.kroah.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_h7/7F4mDk9ihSP1"
Message-Id: <200703081317.37646.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_h7/7F4mDk9ihSP1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 07 March 2007 18:11, Greg KH wrote:
> From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
>
> There is no prompt for STACKTRACE, so it is enabled only when 'select'ed.
> FAULT_INJECTION depends on it, while LOCKDEP selects it. So FAULT_INJECTION
> becomes visible in Kconfig only when LOCKDEP is enabled.

Please replace with the attached patch, sorry for being late (I thought it had 
been dropped). Otherwise a regression would be caused for archs like ia64 on 
allyesconfig; the change is needed, as discussed with Roman Zippel.

> Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  lib/Kconfig.debug |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.20.1.orig/lib/Kconfig.debug
> +++ linux-2.6.20.1/lib/Kconfig.debug
> @@ -400,7 +400,7 @@ config LKDTM
>  config FAULT_INJECTION
>  	bool "Fault-injection framework"
>  	depends on DEBUG_KERNEL
> -	depends on STACKTRACE
> +	select STACKTRACE
>  	select FRAME_POINTER
>  	help
>  	  Provide fault-injection framework.
>
> --

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade

--Boundary-00=_h7/7F4mDk9ihSP1
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-dependency-to-select-fault-inject.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-dependency-to-select-fault-inject.diff"

[PATCH] Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled.

There is no prompt for STACKTRACE, so it is enabled only when 'select'ed.
FAULT_INJECTION depends on it, while LOCKDEP selects it. So FAULT_INJECTION
becomes visible in Kconfig only when LOCKDEP is enabled.

Update: fixed for architectures not supporting STACKTRACE_SUPPORT.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Index: linux-2.6.git/lib/Kconfig.debug
===================================================================
--- linux-2.6.git.orig/lib/Kconfig.debug
+++ linux-2.6.git/lib/Kconfig.debug
@@ -399,8 +399,8 @@ config LKDTM
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
-	depends on DEBUG_KERNEL
-	depends on STACKTRACE
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
+	select STACKTRACE
 	select FRAME_POINTER
 	help
 	  Provide fault-injection framework.

--Boundary-00=_h7/7F4mDk9ihSP1--
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
