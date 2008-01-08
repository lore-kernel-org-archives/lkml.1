Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYAHXvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYAHXvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYAHXuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:50:54 -0500
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:43382 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbYAHXux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:50:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAALqag0ecIvL+/2dsb2JhbAAIqWE
Message-ID: <47840C57.6000304@gmail.com>
Date: Tue, 08 Jan 2008 19:50:47 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com, gorcunov@gmail.com, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org>
In-Reply-To: <20080108164015.GC31504@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Here's a proposal for some useful code transformations the kernel janitors
> could do as opposed to running checkpatch.pl.
> 
<snip>

I notice that every driver in drivers/ata uses a .ioctl that points to
ata_scsi_ioctl().  I could add the BKL to that function, and then change
all of the drivers to .unlocked_ioctl, but I assume this would be a
candidate to actually clean up by determining why the lock is needed and
removing it if necessary.  Does anyone know off-hand the reason for
needing the lock (I assume someone does or it wouldn't have survived
this long)?  If the lock is absolutely required, then I can write the
patch to add lock_kernel() and unlock_kernel().

-- 
Kevin Winchester

