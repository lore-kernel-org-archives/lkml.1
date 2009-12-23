Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZLWRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZLWRLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZLWRLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:11:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41342 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZLWRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q8pPkbKIHJtmEH2afIs9uhtbRb50cu7poxqqcNGAVvLKGG+leKcEIFwd8yU2ZbyBsj
         z+6pu66Dk1piqthTqiLqrvd1K3lmNWhT+CCaX4vHT3/zT1M69Z9c1AUKB1OewTMMetfl
         eVr2x5Ih7EzM3Eak2rcVtXKl2r3FteDFaHhAQ=
MIME-Version: 1.0
In-Reply-To: <43e72e890912230820j5e00b8cbq9ea9009cdcf25a0f@mail.gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
	 <20091219085640.c3414f51.sfr@canb.auug.org.au>
	 <43e72e890912181403k3a194326jbb8ca70a16cdcb74@mail.gmail.com>
	 <1158166a0912230727h5ebbba81w5cb5d10648f791d3@mail.gmail.com>
	 <43e72e890912230820j5e00b8cbq9ea9009cdcf25a0f@mail.gmail.com>
Date: Wed, 23 Dec 2009 18:11:36 +0100
Message-ID: <1158166a0912230911o5c33adfcg9a39da22aec7b44a@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 5:20 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> Is it allocating/using so much memory
>> that your box goes into a severe swap storm?
>
> Could be, 979M virtual, 298M resident size (non swapped), 58665 shared.
>
> Unfortunately when this happens I cannot log into my box and run good
> diagnostics, that's how much of a pain in the bolas this is.

Nicing it may make it easier to do diagnostic work.

> Some
> morning I had enough patience I did leave vmstat and iostat running
> and didn't see much out of the ordinary except CPU wait time was
> pretty high. I did manage to get at least htop running once and took a
> screenshot (and this took me about 10 minutes to generate):
>
> http://bombadil.infradead.org/~mcgrof/images/2009/12/git-merge.jpg

Looks like swap space is 2/3 used. This is an indication
of memory starvation.

It may be a residual condition - you have a lot of potentially
bloated programs running. What do you see if you reproduce
this situation soon after boot, with minimum of other running programs?
For one, definitely do not start web browser(s) and such.
Ideally, do not run X at all.

If you still see a lot of swap used, then this is it - git
requires more memory for this task. The possibility that
kernel has a bug where it needlessly swaps out is remote.

--
vda
