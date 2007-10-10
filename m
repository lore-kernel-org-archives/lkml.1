Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXJJGfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXJJGfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXJJGfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:35:34 -0400
Received: from ozlabs.org ([203.10.76.45]:54185 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbXJJGfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:35:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC REPOST 1/2] paravirt: refactor struct paravirt_ops into smaller pv_*_ops
Date: Wed, 10 Oct 2007 16:35:09 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <470BC758.1030504@goop.org>
In-Reply-To: <470BC758.1030504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710101635.10139.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 04:24:24 Jeremy Fitzhardinge wrote:
> [ I think this is a straight repost this patch, which addresses all the
> previous comments.  I'd like to submit this for .24 as the basis for a
> unified paravirt_ops.  Any objections? ]

Thanks Jeremy, I've actually taken time to finally review this in detail (I'm 
assuming you'll refactor as necessary after the x86 arch merger).

> +	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);

I think this gives the right answer for the wrong reasons?

> +struct paravirt_ops paravirt_ops;
> +

Do you actually need to define this?  See below...

> +DEF_NATIVE(, ud2a, "ud2a");

Hmm, that's ugly.  It was ugly before, but it's uglier now.  Maybe just 
use "unsigned char ud2a[] = { 0x0f, 0x0b };" in paravirt_patch_default?

>  }
>
>  struct paravirt_ops paravirt_ops = {
...
> +	.pv_info = {
> +		.name = "bare hardware",
> +		.paravirt_enabled = 0,
> +		.kernel_rpl = 0,
> +		.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
> +	},

This is the bit I don't get.  Why not just declare struct pv_info pvinfo, etc, 
and use the declaration of struct paravirt_ops to get your unique 
offset-based identifiers for patching?

Rest looks fine...

Thanks!
Rusty.
