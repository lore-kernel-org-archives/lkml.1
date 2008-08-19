Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYHSVGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYHSVGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYHSVGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:06:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:48914 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYHSVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PzFjmw1MvpZMHg8WbGADv9Sbq91oR3keWRy6B/Ljsnw0ONu2dffpUyVth2hpSmOus+
         G2tYpZ+VM1peAMtOZt2pUwIIpoT2GBK+If5choj0MnXD/yadoWUOA+SAwRYFDwMg56vE
         U+S2PzmqgmnLBrPd8WEVPshWzXqxBNULAvYcs=
Message-ID: <ac9c93b10808191406v61ab2df9o486816f8c3b6b0b0@mail.gmail.com>
Date: Tue, 19 Aug 2008 23:06:04 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: inclusion of <endian.h> in a kernel header? ok or not?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080819195239.GA21209@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac9c93b10808191216q64c41222n7752c24c089e3303@mail.gmail.com>
	 <20080819195239.GA21209@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/19 Adrian Bunk <bunk@kernel.org>:
> On Tue, Aug 19, 2008 at 09:16:56PM +0200, Frans Meulenbroeks wrote:
>> Is it ok to #include <endian.h> in a kernel header file.
>> This is done in linux/patchkey.h and linux/soundcard.h but other
>> places seem to prefer <asm/byteorder.h>
>>...
>
> Look at the two files you mention - they only do it in userspace.
>
> And considering that these only users in the kernel are in the OSS code
> it's most likely not the best solution.

Agree.
But as I want to do it right I'd like to know what the best way is.
would that be including <asm/byteorder.h> and then have code with
#ifdef __LITTLE_ENDIAN
#else
#endif
be the preferred solution?

(I don't want to use the conversion functions just want to get the
leftmost short from an uint32_t)

With gcc 4.1.3 (which is the default on my ubuntu 7.10 dev system) a
typecast like
a_short = *(unsigned short volatile *)&a_long;
which would do the trick gives faulty code with -O2 or up.
