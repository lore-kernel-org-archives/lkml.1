Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYGATXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYGATXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYGATWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:22:53 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34234 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYGATWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:22:52 -0400
Message-ID: <486A823C.4070805@nokia.com>
Date: Tue, 01 Jul 2008 22:15:08 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org
CC: ext Alan Stern <stern@rowland.harvard.edu>,
       ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared	interrupt
 handlers
References: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org> <486A590A.4090806@nokia.com> <20080701182543.GA32098@suse.de>
In-Reply-To: <20080701182543.GA32098@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 19:16:01.0015 (UTC) FILETIME=[E6083870:01C8DBAE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Greg KH wrote:
> 
> Hm, isn't this also an issue in 2.6.25 as well?  I've had a few very
> strange reports of USB just locking up in 2.6.25, could this also be the
> cause there?

As I wrote in the first mail of this thread the problem was uncovered on my machine by the following commit from 2.6.24-development:

 commit e9df41c5c5899259541dc928872cad4d07b82076
 USB: make HCDs responsible for managing endpoint queues

The interrupt problem exists also in 2.6.23 (and previous) but the USB code was not affected, as the old versions of the functions were using spin_lock_irqsave().

I just applied my patch to 2.6.24 & 2.6.25: it applies fine and compiles without problem. So it could be submitted to the 2.6.24.X and 2.6.25.X branches too.

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
