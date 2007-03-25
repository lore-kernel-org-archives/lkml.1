Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbXCYPaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbXCYPaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXCYPaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:30:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:31977 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXCYPaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RWNjk/DiEPWY8S8yivqTHVtOkPgXhcb4UFh2c33t3Q+uIWF1vZ99zqtvPR4i6A7ggTMGs+D91XQHOAxb2kvrY6hYaE37buxx4sSYoEJpvt9Coh3q+OIJgHrgKWfiZvveS+CEM+e6vVaEIN4g6bGAPbVlGrGHT51rZmEJK6kl+Wg=
Message-ID: <84144f020703250830k5fb3e2eo6145a88cbe5a859d@mail.gmail.com>
Date: Sun, 25 Mar 2007 17:30:04 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Bin Chen" <binary.chen@gmail.com>
Subject: Re: kmem_cache_create loop for find the proper gfporder
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5800c1cc0703241649q27157d9aid3d9d51b52efbf65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5800c1cc0703241649q27157d9aid3d9d51b52efbf65@mail.gmail.com>
X-Google-Sender-Auth: e8306b7a2f91b06d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/07, Bin Chen <binary.chen@gmail.com> wrote:
> It is done by increase gfporder for low number to high(possibly 0 to
> MAX_GFP_ORDER). But why increase the gfporder(or slab size) can
> decrease the internal fragmentation?)
>
> A simple example, suppose the slab management stuff is kept off-slab,
> if the gfporder is zero, and the object size in slab is 1000, the
> wasted space is 4096 mod 1000 = 96, but with 4096 * 2(increase
> gfporder by 1), the space is 8192 mod 1000 = 192, 192 > 96.

You didn't simulate the algorithm long enough. If you had, you'd hit
order five which wastes only 72 bytes in your example.

                                 Pekka
