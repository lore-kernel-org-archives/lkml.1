Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYJHOLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYJHOLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYJHOLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:11:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51106 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752652AbYJHOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:11:37 -0400
Date: Wed, 8 Oct 2008 10:11:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yi Yang <yi.y.yang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <leonidv11@gmail.com>
Subject: Re: [PATCH] USB: improve ehci_watchdog's side effect in CPU power
 management
In-Reply-To: <1223463117.2845.15.camel@yangyi-dev>
Message-ID: <Pine.LNX.4.44L0.0810081008510.2498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008, Yi Yang wrote:

> CC to Alan Stern and Leonid, maybe they know why "﻿t =
> DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1".

The "DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000)" converts from 
milliseconds to jiffies.  It could easily be replaced with 
msecs_to_jiffies().

The "+ 1" part is there to prevent ties, in case the conversion just
happens to be exact.

Alan Stern

