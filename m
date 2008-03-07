Return-Path: <linux-kernel-owner+w=401wt.eu-S1762409AbYCGNAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762409AbYCGNAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYCGNAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:00:33 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:50757
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbYCGNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:00:33 -0500
Message-ID: <47D13BD1.30801@qumranet.com>
Date: Fri, 07 Mar 2008 14:57:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: headersinstall of kvm.h does not work
References: <200803071326.06682.borntraeger@de.ibm.com>
In-Reply-To: <200803071326.06682.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Hello Avi,
>
> in commit fb56dbb31c4738a3918db81fd24da732ce3b4ae6 you changed 
> include/linux/Kbuild:
> ----snip----
> KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
> Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export 
> kvm.h only if the arch actually supports it.
> [...]
>  unifdef-y += keyboard.h
> -unifdef-y += kvm.h
> +unifdef-$(CONFIG_HAVE_KVM) += kvm.h
>  unifdef-y += llc.h
>  unifdef-y += loop.h
> ----snip------
>
> This patch does not work. Kbuild (scripts/Makefile.headersinst) does not 
> check the config file, so kvm.h is never installed.
>
> Sam is there an easy way to allow constructs like "unifdef-$(CONFIG_FOO)"?
>   

I think this cleverness has caused too much trouble already, and adding 
asm-*/kvm.h would have been better.

As I'm about to disappear for a week, consider a patch to remove the 
config dependency and add asm-*/kvm.h pre-acked for mainline.  Maybe the 
presence of those empty asm-*/kvm.h files will encourage further kvm 
ports to *.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

