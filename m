Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXHSXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXHSXMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 19:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXHSXMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 19:12:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39846
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbXHSXMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 19:12:07 -0400
Date: Sun, 19 Aug 2007 16:12:06 -0700 (PDT)
Message-Id: <20070819.161206.94555994.davem@davemloft.net>
To: andi@firstfloor.org
Cc: felix@chelsio.com, jeff@garzik.org, netdev@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
 PS_TCPportsfrom the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <p73hcmv14wo.fsf@bingen.suse.de>
References: <20070819.123212.13769462.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com>
	<p73hcmv14wo.fsf@bingen.suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: 20 Aug 2007 01:27:35 +0200

> "Felix Marti" <felix@chelsio.com> writes:
> 
> > what benefits does the TSO infrastructure give the
> > non-TSO capable devices?
> 
> It improves performance on software queueing devices between guests
> and hypervisors. This is a more and more important application these
> days.  Even when the system running the Hypervisor has a non TSO
> capable device in the end it'll still save CPU cycles this way. Right now
> virtualized IO tends to much more CPU intensive than direct IO so any
> help it can get is beneficial.
> 
> It also makes loopback faster, although given that's probably not that
> useful.
> 
> And a lot of the "TSO infrastructure" was needed for zero copy TX anyways,
> which benefits most reasonable modern NICs (anything with hardware 
> checksumming)

And also, you can enable TSO generation for a non-TSO-hw device and
get all of the segmentation overhead reduction gains which works out
as a pure win as long as the device can at a minimum do checksumming.
