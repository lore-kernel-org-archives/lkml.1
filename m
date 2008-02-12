Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbYBLXj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbYBLXj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYBLXjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:39:18 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYBLXjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:39:17 -0500
Date: Wed, 13 Feb 2008 00:39:16 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Miller <davem@davemloft.net>
cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
In-Reply-To: <20080212.152652.217936905.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0802130032190.14275@fbirervta.pbzchgretzou.qr>
References: <20080212.001104.172517283.davem@davemloft.net>
 <200802120849.34477.chris.mason@oracle.com>
 <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
 <20080212.152652.217936905.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 12 2008 15:26, David Miller wrote:
>
>> (Yes, I had xfs on sparc before, so it's not like you NEED the 
>> whitespace at the start of a partition.)
>
>You actully do unless you want to lose significant chunks of your disk
>space.
>
>The Sun disk label only allows you to specify the start of a partition
>in cylinders, so if you want to use a filesystem like XFS you have to
>start the partition on cylinder 1 which can be many blocks into the
>disk.  That entire first cylinder is completely wasted.

Ok you do have a point there. The GPT users win of course, since it
uses LBA, not cyls, so the number of lost bytes is generally below
a cyl.
On the other hand, the H and S of CHS could be lowered and S increased,
e.g. divide H by 2, divide S by 2, multiply S by 4. This gives a finer
bytes/cylinder granularity.

>What XFS does by putting the superblock at zero is simply does not
>take these kinds of issues into consideration.
>

Well it was designed for a different system initially with
a different style of booting.
