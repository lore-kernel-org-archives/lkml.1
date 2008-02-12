Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYBLX0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYBLX0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYBLX0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:26:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46402
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYBLX0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:26:20 -0500
Date: Tue, 12 Feb 2008 15:26:52 -0800 (PST)
Message-Id: <20080212.152652.217936905.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
References: <20080212.001104.172517283.davem@davemloft.net>
	<200802120849.34477.chris.mason@oracle.com>
	<Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 12 Feb 2008 15:00:20 +0100 (CET)

> (Yes, I had xfs on sparc before, so it's not like you NEED the 
> whitespace at the start of a partition.)

You actully do unless you want to lose significant chunks of your disk
space.

The Sun disk label only allows you to specify the start of a partition
in cylinders, so if you want to use a filesystem like XFS you have to
start the partition on cylinder 1 which can be many blocks into the
disk.  That entire first cylinder is completely wasted.

What XFS does by putting the superblock at zero is simply does not
take these kinds of issues into consideration.
