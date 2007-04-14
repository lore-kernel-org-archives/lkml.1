Return-Path: <linux-kernel-owner+w=401wt.eu-S1030690AbXDNNPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030690AbXDNNPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030417AbXDNNPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:15:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:5793 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030403AbXDNNPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RHFfFReTT2/yoC/tw0uQra07+5r0c9erN11WkIqjAAnRqGnZGj/p8tEHPAw3WIMDlbTDeiPCVWZvu9yKBsVx6mqIbkLY+LmF1DlE5KYhhiyToAx4U2+Wyl2+4JolIrprJY10fnw2Gbd2qmty7JlcdaOH2/ZjvTf1SUWO7NRy4SU=
Message-ID: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
Date: Sat, 14 Apr 2007 15:15:13 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <E1HcZud-0006DB-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704130630v4c840bd1w19f2a239f86a93b@mail.gmail.com>
	 <E1HcZud-0006DB-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/14/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> It should be easy to restrict a crypto device so that it's used
> by one specific user.  That's why we have generic names ("aes") vs.
> specific ones ("aes-foo").
>
> So if you let the priority user pick "aes-foo" instead of "aes",
> and given that there is a higher priority variant of the generic
> "aes" registered, the system will do exactly what you want.
>

hmm yes indeed it should do the job, but I don't see how you do that.
For example, let say I want to use "aes-foo" with eCryptfs. I can give
a higher priority to "aes-foo" than "aes" one. When eCryptfs asks for
a aes cipher it will pass "aes" name and since "aes-foo" has a higher
priority then the cypto core will return "aes-foo" cipher, right ? But
in this scheme, eCryptfs has not a higher priority than other kernel
users. How can I prevent others to use "aes-foo" ?

Actually I'd like to say "'aes-foo' is a cipher used by one and only
one user". That would allow aes-foo driver to no reload the same key
for each block and to be more efficient for my common case.

thanks
-- 
Francis
