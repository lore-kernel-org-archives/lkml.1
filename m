Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXDNQ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXDNQ7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXDNQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:59:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXDNQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:59:53 -0400
Date: Sat, 14 Apr 2007 09:58:52 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: jeremy@jeremya.com
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [PATCH] usb bulk transfer: 1024 byte packets
Message-Id: <20070414095852.c5e3911a.zaitcev@redhat.com>
In-Reply-To: <9457.24.247.238.75.1176556465.squirrel@secure.gandhilinux.org>
References: <200704131256.47570.jeremy@jeremya.com>
	<20070413191654.1abdbafc.zaitcev@redhat.com>
	<9457.24.247.238.75.1176556465.squirrel@secure.gandhilinux.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007 09:14:25 -0400 (EDT), "Jeremy C. Andrus" <jeremy@jeremya.com> wrote:
> On Fri, April 13, 2007 22:16, Pete Zaitcev wrote:

> > The transfer size in the URB is not limited by the maximum packet
> > size. The HC driver splits up the transfer as specified by URB into
> > the required number of packets.
> 
> The problem was not in the transfer from PC -> Device, but from Device
> -> PC. If I remember correctly, the 512 limit (in the
> urb->transfer_flags) is used to setup the DMA. When the device sent
> packets which were 1024 bytes in size, the urb came back with a status
> set to -EOVERFLOW.

It's a bug in your driver. Supply the correct size with the URB and
all will be fine. Like I said, HC splits up the transfer transparently,
no matter what direction.

-- Pete
