Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZKCTze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZKCTze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZKCTzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:55:33 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:64829 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZKCTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:55:32 -0500
From: Frans Pop <elendil@planet.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] um: minor Makefile simplification through use of cc-ifversion
Date: Tue, 3 Nov 2009 20:55:34 +0100
User-Agent: KMail/1.9.9
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200907232057.51827.elendil@planet.nl>
In-Reply-To: <200907232057.51827.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911032055.36504.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2009 19:55:36.0355 (UTC) FILETIME=[9C41D730:01CA5CBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

You planned to take any of these patches not picked up by arch maintainers 
in kbuild.git. This looks to be the only one not yet included in mainline.

Cheers,
FJP

On Thursday 23 July 2009, Frans Pop wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> ---
>
> Change was suggested by Sam Ravnborg; see
> http://lkml.org/lkml/2009/7/18/15. Untested, but a similar patch for x86
> was tested to work.
>
> diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
> index 302cbe5..2c3e658 100644
> --- a/arch/um/Makefile-i386
> +++ b/arch/um/Makefile-i386
> @@ -35,8 +35,9 @@ cflags-y += -ffreestanding
>  # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc
> use # a lot more stack due to the lack of sharing of stacklots.  Also,
> gcc # 4.3.0 needs -funit-at-a-time for extern inline functions.
> -KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
> -			echo $(call cc-option,-fno-unit-at-a-time); \
> -			else echo $(call cc-option,-funit-at-a-time); fi ;)
> +KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0400, \
> +			$(call cc-option,-fno-unit-at-a-time))
> +KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0400, \
> +			$(call cc-option,-funit-at-a-time))
>
>  KBUILD_CFLAGS += $(cflags-y)

