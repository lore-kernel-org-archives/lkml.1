Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXLSKPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXLSKPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXLSKPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:15:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:49208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXLSKPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=muNTs5KewwtPye9I5e0u86/EJOYhuUv87ssr/WWZ+3JVcvH9IXFct6KiLhOvlBdW5kBLF7ZoKaJWGthIl/BHy/Qq4j6KG3Xjp/f5EQazJ96CJH0lWaRouarG2smCaHTkE1Jj4sm5l8Oucd84hRGcL60L7tMPBlJ/n5lnfP60F0k=
Message-ID: <b6fcc0a0712190215g58de1ad9m53aee165fecaa278@mail.gmail.com>
Date: Wed, 19 Dec 2007 13:15:39 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [patch, rfc] mm.h, security.h, key.h and preventing namespace poisoning
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071219093834.GW4396912@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071219093834.GW4396912@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/07, David Chinner <dgc@sgi.com> wrote:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7cd94146cd504016315608e297219f9fb7b1413b
>
> included security.h in mm.h and that is how I'm seeing the namespace
> poisoning coming from key.h when !CONFIG_KEY.
>
> Including security.h in mm.h means much wider includes for pretty
> much the entire kernel, and it opens up namespace issues like this
> that never previously existed.

ACK, removing sched.h from mm.h was quite painful and security.h
added it back unconditionally. As result, standalone mm.h inclusion goes
from ~9K to ~16K of code after preprocessing which is quite unpleasant.

> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -12,7 +12,6 @@
>  #include <linux/prio_tree.h>
>  #include <linux/debug_locks.h>
>  #include <linux/mm_types.h>
> -#include <linux/security.h>
