Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZG2Uze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZG2Uze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZG2Uzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:55:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34927 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZG2Uzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=sUm6qpHk1u+AOcZ2ODkyq+Qkz66f0GwScUvUypbJqMgtrAhktcCjRhpD7ESg8mrMOa
         vR96s5SLk/mGlbqm47z+gt6QKHH0yfELmGdLxP2UnM/hwx2la7Mijc7smglpO18ZYRpW
         zmMyEoINjPbLl2d+nu9KteiB15llUSqxWTnmQ=
MIME-Version: 1.0
In-Reply-To: <20090729201702.GA28202@linux-sh.org>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
	 <20090729115817.GA12223@rakim.wolfsonmicro.main>
	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
	 <20090729124233.GA12802@rakim.wolfsonmicro.main>
	 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
	 <4A704777.70001@mnementh.co.uk>
	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
	 <4A7053E8.8050303@mnementh.co.uk>
	 <20090729201702.GA28202@linux-sh.org>
Date: Wed, 29 Jul 2009 22:55:31 +0200
Message-ID: <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Ian Molton <ian@mnementh.co.uk>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 10:17 PM, Paul Mundt<lethal@linux-sh.org> wrote:
> On Wed, Jul 29, 2009 at 02:51:36PM +0100, Ian Molton wrote:
>> Magnus Damm wrote:
>> >Note that I don't need clocklib to get the tmio_mmc driver working for
>> >my platform. It's something _you_ need for the MFD chips. But you seem
>> >to want me to fix it for you even though I don't have any particular
>> >need for it.
>>
>> Actually, the tmio-mmc driver works perfectly on the MFD chips right
>> now. These are the chips it was written to handle.
>>
> And these patches are fixing up the mmc driver to support the non-MFD
> case. If you want to fix up the MFD driver to expose a similar interface
> to the mmc one as what we are doing with the clock framework, that is
> fine, but is likewise an unrelated change.
>
> Lets evaluate the clock options we have today:
>
>        1) clock framework
>        2) clkdev

2) is nothing more than an implementation detail of 1). How clk_get
looks up the struct clk internally should not be of any concern to the
consumer.

>        3) clocklib
>
> #1 is what these patches are written for, and the only standard in-tree
> interface that we have cross platform today. #2 could be generalized, but
> that needs discussion by itself, as it was never proposed as a standard
> interface and never submitted to l-k for review. #3 is not in the kernel
> today and it's not clear that it ever will be.

Yes, 3) is unlikely to happen in the near future.

[...]
> If you can show what is wrong with how the clock framework is being used
> in the patch that Guennadi posted, we will certainly rework it as
> necessary. However, I will not at this point be merging clkdev in to my
> architecture tree, and clocklib I have never supported. These are things
> that can be done and supported incrementally, but making these
> prerequisites is simply blocking progress, especially when there is no
> consensus on the clkdev/clocklib parts.

Providing the clock consumer ID via platform data is wrong. As I
understand it, that ID should be either NULL if the clock can be
determined from the struct device pointer (i.e. if it's the only clock
provided to that device), or it should be used to distinguish the
device's clock input pins (in the tmio-mmc case that would be 'hclk'
or 'clk32' if I remember the datasheet correctly).

>> Can we keep it technical now, please?

[...]

regards
Philipp
