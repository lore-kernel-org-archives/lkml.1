Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbYBTT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbYBTT0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765957AbYBTT0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:26:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56736 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761265AbYBTT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:26:17 -0500
Date: Wed, 20 Feb 2008 14:26:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <20080220183041.46c16ef0@mjolnir.drzeus.cx>
Message-ID: <Pine.LNX.4.44L0.0802201418520.7056-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Pierre Ossman wrote:

> Not really. But you have some things confused. What it checks is if
> the mmc bus handler (not a proper driver model, just a way of
> separating the MMC, SD and SDIO stuff) has a resume function. And if
> it doesn't, it removes the card (since it cannot revive it at
> resume).
> 
> So the only thing I can think of is to delay the removal until the
> resume routine, if that is safer.

Do I understand this correctly?  You've got special handling for the 
case where a bus handler doesn't have a resume routine, but no special 
handling for the case where it doesn't have a suspend routine?  Why 
bother to remove the device if neither routine exists (there won't be 
any need to revive it since the bus never got suspended)?

And why not simply fail the suspend if the resume routine doesn't exist
and the suspend routine does?  Maybe with an error message in the
system log.

Alan Stern

