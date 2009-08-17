Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZHQHPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZHQHPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZHQHPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:15:23 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49515 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZHQHPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lH5jdITAAemRt2cWit0IVFcXn/gVW8Dvg0ZB9Bm/WWC2LNQF+nRI6bmnByRgU9WwUN
         wbm6URqTZyFjCS4fwRvcfwAm6+IQqCC/7ZPNnefK0z3K4/OmMDwdV4BV331muNrt12zD
         2sBmrHntjzZk9YdioWChJaThW2I4tac95qSRU=
Message-ID: <4A890388.8070709@gmail.com>
Date: Mon, 17 Aug 2009 09:15:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
References: <20090815134312.GA7533@localdomain.by> <4A86BC96.9040702@gmail.com> <alpine.LFD.2.00.0908150947260.14440@localhost> <20090815141212.GA7692@localdomain.by> <4A871DAF.10609@gmail.com> <20090816091425.GB7968@localdomain.by>
In-Reply-To: <20090816091425.GB7968@localdomain.by>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2009 11:14 AM, Sergey Senozhatsky wrote:
> There are different shr/shl operations in bitblit.c. Like,
> #1
> cur_height = vc->vc_font.height >> 1
> cur_height = (vc->vc_font.height << 1)/3;
> c |= c >> 1;
> u32 idx = vc->vc_font.width >> 3;
> etc.
> 
> So, should I convert it to something like:

Not at all. I was writing about about (X + 7) / 8 [or >> 3] which is
DIV_ROUND_UP(X, 8).

> #2
> cur_height = DIV_XXX(vc->vc_font.height, 2)
> cur_height = DIV_XXX( MUL_XXX(vc->vc_font.height, 2), 3); or cur_height = DIV_XXX( (vc->vc_font.height * 2), 3);
> c |= DIV_XXX(c, 1);
> u32 idx = DIV_XXX(vc->vc_font.width, 8);
> 
> #1 is better-looking I think.

Agreed. I would write it without shifts though. But we were talking
about the roundup case not about the shifts all over the code.
