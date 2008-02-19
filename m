Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYBSTsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYBSTsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761399AbYBSTr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:47:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:34243 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760787AbYBSTr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ksOpQXX1UtaWwyUiIxdtVARgnmBY7aQIvdwOEVT1SPtJ2yhcaq0Zv4C5o9gEiGQ5j0VlEcsR1iIhla93WNBsCQjJio/m6lxr27ub6FaxUOn0VkQA5Kh0HCHBHaO/Bt0CCaftw37uV435SehtvRY+QaZYZNJBF9qho07lgT7M8NQ=
Message-ID: <86802c440802191147u2117a114rf89501341385c705@mail.gmail.com>
Date: Tue, 19 Feb 2008 11:47:56 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Miller" <davem@davemloft.net>, greg@kroah.com
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of parent
Cc: mingo@elte.hu, akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802191142.48891.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
	 <20080219112146.GC7204@elte.hu>
	 <20080219.034110.191579889.davem@davemloft.net>
	 <200802191142.48891.yinghai.lu@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 11:42 AM, Yinghai Lu <Yinghai.Lu@sun.com> wrote:
> On Tuesday 19 February 2008 03:41:10 am David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 19 Feb 2008 12:21:46 +0100
> >
> > >
> > > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > >
> > > >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> > > >           unsigned int length, gfp_t gfp_mask)
> > > >  {
> > > > - int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > > > + int node = dev_to_node(&dev->dev);
> > >
> > > i think this is a fix for the networking folks. (Dave Cc:-ed)
> >
> > It keeps getting NAK's because it's wrong.
> >
> > The author of the patch hasn't convinced folks why this is really
> > necessary, and using the net_device embedded device struct is
> > definitely wrong here.  It doesn't contain the NUMA node information,
> > the physical device does, and that is what the parent it.
>
> can you check the 5/8?
> that will make sure every struct device get numa_node get assigned.
>
> YH
>
or need to combine 5 and 6 together?

YH
