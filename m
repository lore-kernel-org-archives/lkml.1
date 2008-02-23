Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbYBWLwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbYBWLwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbYBWLwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:52:15 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:37038 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbYBWLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l50+qCATIqa39r9D3pZOh2mSvkElW+BG3kdpXj941EF67NKZM4ySfR0z5TnWB7Ycu5/7OBqtGMNp8/kh9RRD6P4iVYZXlkzPO3roz8pNiplGmJ942r43c23VNj8P90cuJJDqLWHDHPJ+gyJfUGvm2/+FeX2cTquNj5i/vB+1xhM=
Message-ID: <f19298770802230351i7a1bdba8pcb1faf4af9b7d385@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:51:43 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Michael Buesch" <mb@bu3sch.de>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <84144f020802230337s35c72b50wf8b892777bff42a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
	 <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <20080223110751.GN23833@elte.hu>
	 <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
	 <20080223112436.GA31304@elte.hu>
	 <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
	 <84144f020802230337s35c72b50wf8b892777bff42a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 2:37 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Sat, Feb 23, 2008 at 1:32 PM, Alexey Zaytsev
>  <alexey.zaytsev@gmail.com> wrote:
>  >  The problem is not with enabling both b43 and bcm43xx (will, whis won't work
>  >  anyway, and there is no chance fixing it). The problem is with enabling the
>  >  bcm43xx wifi driver and the b44 Ethernet driver. The ethernet driver then
>  >  wrongly autosolects some config options that prevent the bcm43xx
>  >  driver from loading, so I'm left with either no wifi or no ethenet.
>
>  So does reverting commit 753f492093da7a40141bfe083073400f518f4c68
>  ("[B44]: port to native ssb support") fix the regression?
>

Compiling it right now.

I'm sure it fixes the problem, but I don't feel like we should revert
it. I can't
be sure it won't cause any other problems, and anyway, this does not look
right a solution. Any other driver (rightfully) requiring the SSB_HOST would
then also break the bcm43xx driver.

I'll send an simplified patch in a few minutes.
