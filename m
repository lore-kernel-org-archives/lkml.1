Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXL3MOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXL3MOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 07:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXL3MN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 07:13:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbXL3MNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 07:13:55 -0500
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <200712292242.47960.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
	 <200712292242.47960.david-b@pacbell.net>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 13:13:51 +0100
Message-Id: <1199016831.31975.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 22:42 -0800, David Brownell wrote:
> On Saturday 29 December 2007, Alan Stern wrote:

> > There's no way to remove these, which means there's 
> > no way to prevent lockdep from issuing a warning.
> 
> There may be no *efficient* way to do that.  If it tracked
> every lock individually these false alarms could go away;
> but that would increase the overhead to create and destroy
> such locks too.

No, tracking locks individually defeats the power of lockdep, that is
warning of lock inversion before it actually happens. That really
requires classes.

Annotating a tree requires grouping per level, and that isn't
particularly hard (although I haven't yet tried it for the device tree -
doing this conversion is still on my todo list). The hardest part of the
device->sem conversion is the suspend/resume part, where it locks the
whole tree and lockdep is limited in tracking held locks.



