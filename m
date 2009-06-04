Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZFDOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZFDOKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZFDOKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:10:43 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58347 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZFDOKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mFbco0fFKCMbJoj0pb+Zs3qmLCn5KJmdD/Yi3pbLcNLdX0uTMGoKFhv+wOGbG8X2Mp
         k4WxTGJBo8i4B85NVfV3Syo22iL6OVrTH+guY5BPl3/wkb5XYZHt70KX71tBzb9Gm/Wk
         ME7HnMF4bgrgsysA7gqudXvaXXUiWBUdlLBiM=
MIME-Version: 1.0
In-Reply-To: <20090604134455.GB2839@tuxdriver.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-2-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
	 <20090603173214.6d3997f7.akpm@linux-foundation.org>
	 <20090604111634.GA28064@doriath.ww600.siemens.net>
	 <20090604134455.GB2839@tuxdriver.com>
Date: Thu, 4 Jun 2009 18:10:41 +0400
Message-ID: <bc64b4640906040710p5c7c941fi3341599bc3157b79@mail.gmail.com>
Subject: Re: [PATCH 03/10] net: add IEEE 802.15.4 socket family implementation
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/4 John W. Linville <linville@tuxdriver.com>:
> On Thu, Jun 04, 2009 at 03:16:34PM +0400, Dmitry Eremin-Solenikov wrote:
>> On Wed, Jun 03, 2009 at 05:32:14PM -0700, Andrew Morton wrote:
>> > On Mon,  1 Jun 2009 18:54:44 +0400
>> > Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
>
>> > > + switch (addr->addr_type) {
>> > > + case IEEE802154_ADDR_LONG:
>> > > +         rtnl_lock();
>> > > +         dev = dev_getbyhwaddr(net, ARPHRD_IEEE802154, addr->hwaddr);
>> > > +         if (dev)
>> > > +                 dev_hold(dev);
>> > > +         rtnl_unlock();
>> > > +         break;
>> > > + case IEEE802154_ADDR_SHORT:
>> > > +         if (addr->pan_id != 0xffff && addr->short_addr != IEEE802154_ADDR_UNDEF && addr->short_addr != 0xffff) {
>> > > +                 struct net_device *tmp;
>> > > +
>> > > +                 rtnl_lock();
>> > > +
>> > > +                 for_each_netdev(net, tmp) {
>> > > +                         if (tmp->type == ARPHRD_IEEE802154) {
>> > > +                                 if (IEEE802154_MLME_OPS(tmp)->get_pan_id(tmp) == addr->pan_id
>> > > +                                   && IEEE802154_MLME_OPS(tmp)->get_short_addr(tmp) == addr->short_addr) {
>> >
>> > You must use very wide xterms :(
>>
>> ~120 chars in width :)  We prefer to have a single code line split between
>> several screen lines, rather than split it manually in some weird places
>> just to justify width of 80 chars.
>
> Hopefully you realize that many find this difficult to read -- I just
> can't spread my eyes far enough to comprehend the lines.
>
> 80 chars is not a hard limit, but it is a good goal.  120 is too wide.

We do try to fit the lines into 80 chars, but when that seems logical.
I strongly dislike breaking comparations between lines.

-- 
With best wishes
Dmitry
