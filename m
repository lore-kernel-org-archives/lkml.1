Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbYIEKif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbYIEKif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYIEKi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:38:27 -0400
Received: from mail.bglans.net ([217.79.67.244]:47803 "EHLO mail.bglans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYIEKi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:38:26 -0400
Date: Fri, 5 Sep 2008 13:37:35 +0300 (EEST)
From: ivaylo@bglans.net
To: Willy Tarreau <w@1wt.eu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Marvel IDE 88SE6101 2.4.XX support
In-Reply-To: <20080905040326.GB17104@1wt.eu>
Message-ID: <Pine.LNX.4.64.0809051317430.9897@mail.bglans.net>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
 <Pine.LNX.4.64.0809042115350.11281@mail.bglans.net>
 <20080904193625.652bf013@lxorguk.ukuu.org.uk> <20080905040326.GB17104@1wt.eu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1339683907-1998988427-1220611055=:9897"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1339683907-1998988427-1220611055=:9897
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Hello,

Thanks, Alan for your comment about Marvell PATA IDE driver.
In this time I'm a litle bit busy and do not have time to backport driver 
in 2.4 probably after a time I'll try (I'm not a profesional C programer 
and it is litle hard to me). I correct generic IDE patch and send you in 
the attached file.


I make also patch to update e1000 driver in the 2.4 kernel to e1000-7.6.5 and 
add support for:
00:19.0 Ethernet controller: Intel Corporation 82801I (ICH9 Family) 
Gigabit Ethernet Controller (rev 02)

But I'm not sure if there are any license violations and any other person 
who manage network drivers to send it to him. If you know something about 
it please tell me to send the patch for testing and e.t.c.


Best Regards,
Ivaylo Josifov



On Fri, 5 Sep 2008, Willy Tarreau wrote:

> Hi Alan,
>
> On Thu, Sep 04, 2008 at 07:36:25PM +0100, Alan Cox wrote:
>> On Thu, 4 Sep 2008 21:26:12 +0300 (EEST)
>> ivaylo@bglans.net wrote:
>>
>>>
>>> Another one small patch to support Marvel IDE 88SE6101 controler. I have
>>> one on Intel DG33BU motherboard. It is detect as
>>> 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 single-port
>>> PATA133 interface (rev b2)
>>
>> Its a pretty generic device - see drivers/ata/pata_marvell.c so IDE
>> generic will probably do roughly the right things. The pata_marvell
>> driver documents how to do cable detect, which you may want to add and
>> make it its own driver.
>
> Indeed, your driver is clear enough to serve as a doc. Looking at
> ata_piix.c in 2.4, I see that the libata core has evolved a lot,
> but backporting your work should not be hard at all. Among other
> things, the driver needs to set ap->cbl itself during reset, for
> instance.
>
> However, I wonder if it's really worth doing it if the IDE generic
> driver already works. The PATA port on such motherboards today is
> mostly used by CD/DVD, and I think that even if we limit ourselves
> to 40-pin, it's not dramatic (all my IDE CD drives have always been
> running that way for ages).
>
> Or maybe this would be more interesting for other chips of the same
> family ?
>
> Ivaylo, if you're interested in trying to backport pata_marvell.c
> from 2.6 to 2.4, that's fine for me, just inform me so that I know
> I'm waiting for you. Otherwise I can merge your IDE generic patch.
> In this case, could you repost your patch after fixing the name
> "MARVEL" in the PCI IDs (=> "MARVELL") ?
>
> Thanks,
> Willy
>
--1339683907-1998988427-1220611055=:9897
Content-Type: APPLICATION/octet-stream; name=Marvell-IDE.patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0809051337350.9897@mail.bglans.net>
Content-Description: 
Content-Disposition: attachment; filename=Marvell-IDE.patch.gz

H4sICCQHwUgAA01hcnZlbC1JREUucGF0Y2gArVRdj5pAFH2GXzHZvu2AzCCi
pWkiCyalUdm4W5M+ET7GMomLG/zoJhv/ey8DVtgFbZsSknu553iAc48kfLVC
ar5HoZbk/MDyrcYTpj3HXPvBMpbzuBejqBuTVVW99FtJJ2SkEgonooZFTMsg
PXI6ECaAyxjjS/eoNAYq0RHRrcHQ0kcNjT5ojMdIpYahmAgXZYjGYxlJr+je
8YLlZO76i8Bzg0f/4Yt3Zyti7E6WnjOpjYN7z3H8qR9QBQmGPf8OsNLoiTgp
OSr/rq9f16et+l9nnrPw52/1q3Ggk77ZB+3iuKKvgz5+pz+zF8vJdFo93vkG
1TwwKaF/pt+vnh/6ojt+kpGcXA9beiEI6ZWwpf8hbOnbsI0s2hE2cyjCBoWa
ZdqkXpyGWcbWW+kzooqYhPvdJnkKYTD37W+PvjuzSyDabHZhtGaAwObufHvh
Fhs5Kq/CXu0WPES3Goyk3oFlySaXgNq+LkFK2IHH7ETq2J1gZuGT4N3UoZsS
4xnfBXHKn7dsB5T6ZVCZVCOmP/nqxCr6Fkr58qe2SWjahbvswl12ocIu4ebZ
IVLae3YDBvXk8Sxe72Hra57tX4rdBzzZitx1IFXqOtC/yNxlhd+J0y2DtiZO
p2Sg9BEWtYzch4SteMbavxKSRF7ox2HUpHV8NYCrQ4F/KW4XrbIiRGkYNWnt
aQNqUWQsy78As0T1KGgGAAA=

--1339683907-1998988427-1220611055=:9897--
