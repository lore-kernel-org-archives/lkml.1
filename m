Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZGXJYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZGXJYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZGXJYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:24:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:29056 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZGXJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BNXUjjBrzDfiGlaMm0tm4+ADm2sFH1LgqeSegHa6iURWiQZOXllDdYBpym/lvlHVRS
         9yLDqSGgW2+RNn0cTQG0UZ4l4aw+hPKvJFUrJv8jKDUItqkX3Btq15j/Xac7zdgv0Jd5
         YTwnVt8s7vNUsFZdHg74UIUIgK1dIfpPEPHmE=
Date: Fri, 24 Jul 2009 17:26:44 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Subject: Re: [PATCH] x86: minor Makefile simplification through use of
	cc-ifversion
Message-ID: <20090724092644.GE6372@cr0.nay.redhat.com>
References: <200907232056.28635.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907232056.28635.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 08:56:27PM +0200, Frans Pop wrote:
>Signed-off-by: Frans Pop <elendil@planet.nl>
>---
>
>Change was suggested by Sam Ravnborg; see http://lkml.org/lkml/2009/7/18/15.
>Tested to work correctly.


Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>
>diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>index 1b68659..1f3851a 100644
>--- a/arch/x86/Makefile
>+++ b/arch/x86/Makefile
>@@ -32,8 +32,8 @@ ifeq ($(CONFIG_X86_32),y)
> 
>         # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
>         # a lot more stack due to the lack of sharing of stacklots:
>-        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
>-                echo $(call cc-option,-fno-unit-at-a-time); fi ;)
>+        KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0400, \
>+				$(call cc-option,-fno-unit-at-a-time))
> 
>         # CPU-specific tuning. Anything which can be shared with UML should go here.
>         include $(srctree)/arch/x86/Makefile_32.cpu
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
