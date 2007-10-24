Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXJXQUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXJXQUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXJXQT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:19:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:41832 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbXJXQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZJAzJsALPiLoco/HCG2ZtPV3kLnO5zL620i7YhF26LCl36/FQokr9m6NSncXTmtAVymRIhOOhVHynI1mlBwfT2M4bAGXSvVQGWco3ApO4UkAg1W2SbvGPCWGGbnYPl6pNQv36XXhojrPYygxXcA12ExffTCZjUn0mOnpqbFbRBQ=
Message-ID: <8bd0f97a0710240919l36547278w9fdb36fd2a6fe34a@mail.gmail.com>
Date: Wed, 24 Oct 2007 12:19:52 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: history of extratext sections?
Cc: paulus@samba.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200710240836.13412.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710240836.13412.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>  - make the check dependant on extratext being populated
> ===================================================================
> --- linux-2.6.x/kernel/kallsyms.c       (revision 3760)
> +++ linux-2.6.x/kernel/kallsyms.c       (working copy)
> @@ -51,7 +51,8 @@
>  static inline int is_kernel_extratext(unsigned long addr)
>  {
>         if (addr >= (unsigned long)_sextratext
> -           && addr <= (unsigned long)_eextratext)
> +           && addr <= (unsigned long)_eextratext
> +           && _sextratext && _eextratext)
>                 return 1;
>         return 0;
>  }

i think you'd want:
if (_sextratext && _eextratext &&
  ... everything else ...
-mike
