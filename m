Return-Path: <linux-kernel-owner+w=401wt.eu-S932755AbZHDJ7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbZHDJ7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932606AbZHDJ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:59:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52853 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZHDJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X/skAUNB2b6GafEVeBwXY7NakYMiv4/glqieHqlU3bVgpNf6tNeTopSifxiNQ0q9Wa
         RisWs5b2gZCJF54Yq8PeRKtGoP0C1A70PVYR9PITwLl5zYfOEoJWcJd2fXH2Zj1BS7Im
         Q/3rVlCrdQ8EkJLbBPEaZUXroK4CzBkx2uZqw=
MIME-Version: 1.0
In-Reply-To: <4A77FCFB.9020001@inria.fr>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
	 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
	 <4A77FCFB.9020001@inria.fr>
Date: Tue, 4 Aug 2009 11:59:08 +0200
Message-ID: <c384c5ea0908040259k4295c986wdd45fe9e1e4315b1@mail.gmail.com>
Subject: Re: get_user_pages() on an mmap()ed file allowed? What to do if 0 < 
	get_user_pages(..., nr_pages, ...) < nr_pages?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Brice,

On Tue, Aug 4, 2009 at 11:18 AM, Brice Goglin<Brice.Goglin@inria.fr> wrote:
> Hugh Dickins wrote:
>>> - what should a driver do when get_user_pages() returns less pages
>>> than requested?
>>
>> Probably put_page the pages gotten then report the surprise;
>> perhaps, before putting the pages gotten, try get_user_pages
>> on the next alone, to see what error code is returned for that.
>
> I wonder if we should change get_user_pages to store ERR_PTR(ret)
> in page[i] when it fails to get page #i.
>
Yes, I would see that as an improvement in finding out why rc <
nr_pages, in case rc > 0.

Also I think it does not break existing users.

Regards,

-- 
Leon
