Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbXJ0SfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbXJ0SfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXJ0SfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:35:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXJ0Se7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=upctmUOo4fZRVurbtbiJSpRTlP65+wL19aaf+Pr3qNOLoHAHw/hEVpWwQlCYhj3VnmBCGFkgOLNKnCzyt7LDyr3/bCGmCY9klRtqrz2Y3aH+HBGgsCRmKswK6XqFL6DI89bUOBAWDsbEJ+9+edSpi0pjrDBkbRr69qCzIfHyhVo=
Date: Sat, 27 Oct 2007 22:34:53 +0400
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc1 sysctl table check failed on PowerMac
Message-ID: <20071027183453.GB9816@martell.zuzino.mipt.ru>
References: <200710271757.l9RHvcY9021751@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710271757.l9RHvcY9021751@harpo.it.uu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 07:57:38PM +0200, Mikael Pettersson wrote:
> Booting 2.6.24-rc1 on my PowerMac the kernel now spits
> out a sysctl warning early in the boot sequence:
> 
> --- dmesg-2.6.23
> +++ dmesg-2.6.24-rc1
> ...
>  IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>  TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>  TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
>  TCP: Hash tables configured (established 131072 bind 65536)
>  TCP reno registered
> +sysctl table check failed: /kernel .1 Writable sysctl directory

[PATCH] powerpc: fix sysctl whining re kernel.powersave-nap

kernel was marked with 0755. Everywhere else it's 0555.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/powerpc/kernel/idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -122,7 +122,7 @@ static ctl_table powersave_nap_sysctl_root[] = {
 	{
 		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0755,
+		.mode		= 0555,
 		.child		= powersave_nap_ctl_table,
 	},
 	{}
