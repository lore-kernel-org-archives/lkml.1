Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbXKCTsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbXKCTsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbXKCTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:48:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757051AbXKCTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:48:29 -0400
Date: Sat, 3 Nov 2007 12:48:23 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: device struct bloat
Message-ID: <20071103124823.6059640e@shemminger-laptop>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sizeof(struct device) is way too big, especially in the network device case.
We want to support 1000's of device's and the change from class_device to
net_device has caused needless bloat.

sizeof(struct device) = 272
sizeof(struct class_device) = 92
  * not the class_id in class_device could also be removed or changed to
     a ptr, since it is redundant for net_devices.

