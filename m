Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYDBG0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYDBG0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYDBG0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:26:08 -0400
Received: from 1wt.eu ([62.212.114.60]:1098 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYDBG0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:26:07 -0400
Date: Wed, 2 Apr 2008 08:25:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080402062543.GA5950@1wt.eu>
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <878wzx25s7.fsf@basil.nowhere.org> <47F21B47.4000206@yandex.ru> <47F26278.5070009@zytor.com> <20080401212652.GD23796@1wt.eu> <47F30FDD.5080003@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F30FDD.5080003@yandex.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 07:47:25AM +0300, Artem Bityutskiy wrote:
> Willy Tarreau wrote:
> >>Well, even auto-levelling storage should benefit from a filesystem which 
> >>minimizes the total number of flash sectors churned, which means doing 
> >>as few writes as possible and to large, contiguous sections.
> >
> >Exactly. At exosec, we ship one appliance which writes statistics to a
> >partition on a compactflash every 5 minutes. We preferred to go with JFFS2
> >exactly because of this reason. We never had any problem proceeding this 
> >way.
> >I'm not sure if it would have been the same with ext2 though.
> >
> 
> Yes, as I agreed in a previous mail this may make sense in some cases.
> 
> But in general it is not a good approach. Basically, it is wastage of 
> resources.
> Indeed, first the firmware on MMC/SD/etc makes efforts to make flash look
> like a block device. It gives you in-place updates,

One of the problem is that unless you crash-test your flash cards, you will
never know if their wear-leveling algorithm is fine or not. And I suspect
that nowadays, due to very large consumer demand, flash cards price drop
at the cost of reliability. I think that most of those not flagged
"industrial-grade" do absolutely zero wear-leveling, because they are sold
to people using them in digital cameras, and they will never kill their
device with such a usage.

> but by cost of performance
> and reliability. Then you just drop this nice property, and use JFFS2, which
> assumes it has only out-of-place updates. But if this solves the task you 
> have

I'm certainly not the only one with this requirement. A lot of embedded
motherboards come with IDE compactflash connectors. This is very convenient,
but if you need to keep informations between reboots, you have to write to
the device anyway. If you need to do that very often, either you pray for
the device to be very reliable, or you take all the chances on your side
by adding your own wear-leveling "just in case".

Cheers,
Willy

