Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbXGITd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbXGITd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXGITdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:33:21 -0400
Received: from thumper2.emsphone.com ([199.67.51.102]:52123 "EHLO
	thumper2.emsphone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXGITdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:33:21 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 15:33:20 EDT
Date: Mon, 9 Jul 2007 14:22:21 -0500
From: Andy <genanr@emsphone.com>
To: Lars Michael =?iso-8859-1?Q?Jogb=E4ck?= <lm@swip.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with size after growing a device
Message-ID: <20070709192221.GA11684@thumper2>
References: <468A27B8.9000107@swip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <468A27B8.9000107@swip.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:40:56PM +0200, Lars Michael Jogbäck wrote:
> Hi,
> 
> So, if I do:
> # cat /sys/block/sdk/size
> 4882708480
> 
> and
> # blockdev --getsz /dev/sdk
> 3906166784
> 
> Apparently /sys/block/sdk/size is updated with the new size, but 
> whatever "blockdev --getsz" and "pvresize" is querying is not. If I 
> reboot, everything works correctly.
> 
I have mentioned this problem before with resizing non-partitioned devices,
then trying to resize the filesystem.  

I consider the issue a bug, because different parts of the kernel have
a different size for the same device.  It should be consistent, preferably
with the new size being reported both by the sys fs and by blockdev (then
hopefully xfs_growfs will work without a reboot).  

Andy
