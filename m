Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXDPIhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXDPIhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965104AbXDPIhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:37:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:44302 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158AbXDPIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eHC5WwQf8gLMR3yHeCRiaD5+7QrO0ap+ohLcRPTE0wtkXJW9wRDnixH1JMOuDz5GpD4Mz3SYjkWcNMH+ZAFdM7A9tF1Ovks/jc8Ql47rdB9pFFEuz1pXi96/+qJ08i19F8ufXuDMog6q2Dy9n8PuhGT/ln7fNjSss7BGA1JjEdc=
Message-ID: <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com>
Date: Mon, 16 Apr 2007 10:37:01 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <20070415075201.GA1644@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
	 <20070415075201.GA1644@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Apr 14, 2007 at 11:10:08PM +0200, Francis Moreau wrote:
> >
> > ok but do you think it's safe to assume that no others parts of the
> > kernel will request "aes-foo" ? Remember that the main point is to
> > optimize "aes-foo" ?
>
> What they request is up to the administrator.
>

But do you think it's safe to design aes driver that could work only
with one kernel user and to rely on administrator config to verify
this condition ?

BTW, here are figures I got with 2 different versions of the driver
when using tcrypt module. The second being the result with the
optimized driver (no key reloading on each block):

normal version:
test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192 bytes)

optimized version:
test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192 bytes)

So the gain is 16000 cycles which seems to worth the change, isn't it ?

thanks
-- 
Francis
