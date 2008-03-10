Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbYCJJf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbYCJJf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYCJJfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:35:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36046 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbYCJJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:35:19 -0400
Date: Mon, 10 Mar 2008 09:22:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080310092213.7ba878b3@core>
In-Reply-To: <200803092346.17556.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So now you can ask some hard questions: what if the power goes out 
> completely or the host crashes or something else goes wrong while 
> critical data is still in the ramdisk?  Easy: use reliable components.  

Nice fiction - stuff crashes eventually - not that this isn't useful. For
a long time simply loading a 2-3GB Ramdisk off hard disk has been a good
way to build things like compile engines where loss of state is not bad.

> If UPS power runs out while ramback still holds unflushed dirty data 
> then things get ugly.  Hopefully a fsck -f will be able to pull 
> something useful out of the mess.  (This is where you might want to be 
> running Ext3.)  The name of the game is to install sufficient UPS power 
> to get your dirty ramdisk data onto stable storage this time, every 
> time.

Ext3 is only going to help you if the ramdisk writeback respects barriers
and ordering rules ?

>  * Previously saved data must be reloaded into the ramdisk on startup.

/bin/cp from initrd

>  * Cannot transfer directly between ramdisk and backing store, so must 
>    first transfer into memory then relaunch to destination.

Why not - providing you clear the dirty bit before the write and you
check it again after ? And on the disk size as you are going to have to
suck all the content back in presumably a log structure is not a big
concern ?

>  * Per chunk locking is not feasible for a terabyte scale ramdisk.

And we care  8) ?

>   * Handle chunk size other than PAGE_SIZE.

If you are prepared to go bigger than the fs chunk size so lose the
ordering guarantees your chunk size really ought to be *big* IMHO

Alan
