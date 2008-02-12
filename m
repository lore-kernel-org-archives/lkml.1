Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYBLOWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYBLOWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759996AbYBLOVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:21:55 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38261 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759998AbYBLOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:21:54 -0500
Date: Tue, 12 Feb 2008 15:21:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Mason <chris.mason@oracle.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
In-Reply-To: <200802120908.59602.chris.mason@oracle.com>
Message-ID: <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
References: <200802061200.14690.chris.mason@oracle.com>
 <200802120849.34477.chris.mason@oracle.com>
 <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
 <200802120908.59602.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 12 2008 09:08, Chris Mason wrote:
>> >
>> >So, if Btrfs starts zeroing at 1k, will that be acceptable for you?
>>
>> Something looks wrong here. Why would btrfs need to zero at all?
>> Superblock at 0, and done. Just like xfs.
>> (Yes, I had xfs on sparc before, so it's not like you NEED the
>> whitespace at the start of a partition.)
>
>I've had requests to move the super down to 64k to make room for bootloaders, 
>which may not matter for sparc, but I don't really plan on different 
>locations for different arches.

In x86, there is even more space for a bootloader (some 28k or so)
even if your partition table is as closely packed as possible,
from 0 to 7e00 IIRC.

For sparc you could have something like

			startlba	endlba	type
	sda1		0		2	1 Boot
	sda2		2		58	3 Whole disk
	sda3		58		90000	83 Linux

and slap the bootloader into "MBR", just like on x86.
Or I am missing something..
