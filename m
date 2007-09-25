Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbXIYQxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbXIYQxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXIYQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:52:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58110 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXIYQw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:52:57 -0400
Date: Tue, 25 Sep 2007 18:52:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miloslav Semler <majkls@prepere.com>
cc: serge@hallyn.com, davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
In-Reply-To: <46F9351D.8020906@prepere.com>
Message-ID: <Pine.LNX.4.64.0709251847570.945@fbirervta.pbzchgretzou.qr>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
 <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5>
 <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com>
 <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com>
 <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com>
 <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com>
 <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com>
 <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr>
 <46F92C17.3060405@davidnewall.com> <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr>
 <46F9351D.8020906@prepere.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25 2007 18:19, Miloslav Semler wrote:
>> > > So what? Just do this: chdir into the root after chroot.
>> > >       
>> > I don't think so.  His exploit just got me all the way out of a chroot
>> > within a
>> > chroot within a chroot, inclusive of lots of chdirs.
>> >     
>>
>> Close all fds that point to directories outside the root ;-)
>>   
> This  does not help.  Let's try:
> chroot somewhere
> mkdir foo
> fd = open /
> chroot foo

('fd' implicitly closed and chdir to /foo)

> fchdir fd

-EINVAL

> chdir ".."

/../ => /

> ....
> chdir ".."
> chroot "."
> so you are in root.

so we remain in chroot.
