Return-Path: <linux-kernel-owner+w=401wt.eu-S965648AbXBTDsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbXBTDsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965652AbXBTDsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:48:10 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:33627 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965648AbXBTDsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:48:09 -0500
Date: Mon, 19 Feb 2007 22:48:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Douglas Gilbert <dougg@torque.net>
cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       <linux-kernel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <45DA23C7.6090800@torque.net>
Message-ID: <Pine.LNX.4.44L0.0702192238110.4237-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Douglas Gilbert wrote:

> Alan,
> The SG_GET_RESERVED_SIZE ioctl is also defined in
> the block layer, see block/scsi_ioctl.c .

Ah, I didn't know that.  (Or more likely, I used to know and have since 
forgotten.)  Thanks for pointing it out.

> I suspect it is just a kludge to fool cdrecord that it
> is talking to a sg device. [One of many kludges in the
> block SG_IO ioctl implementation to that end.]
> So perhaps the block layer versions of SG_SET_RESERVED_SIZE
> and SG_GET_RESERVED_SIZE need to be similarly capped.

Yes.  In fact one of them already is, but the other should be too.

> Actually I think that I would default SG_GET_RESERVED_SIZE to
> request_queue->max_sectors * 512 in the block layer
> implementation (as there is no "reserve buffer" associated
> with a block device).

Okay.

Come to think of it, the reserved_size value used when a new sg device is
created should also be capped at max_sectors * 512.  Agreed?  I can't see
any reason for ever having a larger buffer -- it would be impossible to
make use of the extra space.

Alan Stern

