Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbYBLOAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbYBLOAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbYBLOA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:00:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:44345 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761344AbYBLOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:00:22 -0500
Date: Tue, 12 Feb 2008 15:00:20 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Mason <chris.mason@oracle.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
In-Reply-To: <200802120849.34477.chris.mason@oracle.com>
Message-ID: <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
References: <200802061200.14690.chris.mason@oracle.com>
 <20080211.232139.14959431.davem@davemloft.net> <20080212.001104.172517283.davem@davemloft.net>
 <200802120849.34477.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 12 2008 08:49, Chris Mason wrote:
>> >
>> > This is a real issue on sparc where the default sun disk labels
>> > created use an initial partition where block zero aliases the disk
>> > label.  It took me a few iterations before I figured out why every
>> > btrfs make would zero out my disk label :-/
>>
>> Actually it seems this is only a problem with mkfs.btrfs, it clears
>> out the first 64 4K chunks of the disk for whatever reason.
>
>It is a good idea to remove supers from other filesystems.  I also need to add 
>zeroing at the end of the device as well.
>
>Looks like I misread the e2fs zeroing code.  It zeros the whole external log 
>device, and I assumed it also zero'd out the start of the main FS.
>
>So, if Btrfs starts zeroing at 1k, will that be acceptable for you?

Something looks wrong here. Why would btrfs need to zero at all?
Superblock at 0, and done. Just like xfs.
(Yes, I had xfs on sparc before, so it's not like you NEED the 
whitespace at the start of a partition.)

