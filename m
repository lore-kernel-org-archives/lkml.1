Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXDNVKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXDNVKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXDNVKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:10:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:54546 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXDNVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SGv64IaEDGptx5cuTaf597L3Gbu1mNkvVPv0tg1v6EVd/DGqa5/9jxKqDy7EDVUOCqJFP1rBlfMgBgld78ZMMsweCx4JepEMjcmjsapYPXNwwkvEROCX0dU4i5voEp9XDJzbIgIJy6B1PdGtlS+0OD4B0ei9LH0M+gZrnYuMklU=
Message-ID: <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
Date: Sat, 14 Apr 2007 23:10:08 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Francis Moreau <francis.moro@gmail.com> wrote:
> >
> > hmm yes indeed it should do the job, but I don't see how you do that.
> > For example, let say I want to use "aes-foo" with eCryptfs. I can give
> > a higher priority to "aes-foo" than "aes" one. When eCryptfs asks for
> > a aes cipher it will pass "aes" name and since "aes-foo" has a higher
> > priority then the cypto core will return "aes-foo" cipher, right ? But
> > in this scheme, eCryptfs has not a higher priority than other kernel
> > users. How can I prevent others to use "aes-foo" ?
>
> You would assign "aes-foo" a lower priority and then tell eCryptfs to
> use "aes-foo" instead of "aes".
>

ok but do you think it's safe to assume that no others parts of the
kernel will request "aes-foo" ? Remember that the main point is to
optimize "aes-foo" ?

I would say that it would be better if "aes-foo" could raise a flag
for example indicating to the crypto core that this algo can be
instatiate only one time...

thanks
-- 
Francis
