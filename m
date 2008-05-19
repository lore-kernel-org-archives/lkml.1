Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbYESTRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbYESTRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbYESTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:17:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34394 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754235AbYESTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:17:19 -0400
Date: Mon, 19 May 2008 15:17:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
In-Reply-To: <4831B2E2.8030700@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0805191514300.2111-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Boaz Harrosh wrote:

> Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
> spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
> places that initiate a MODE_SENSE command, specifically at
> scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)

I can't send such a fix because at these places the residue information 
has already been lost.  The fix needs to be made lower down.


Besides, everybody seems to be missing an important point.

MODE SENSE is just one example of a command for which a device might
return less data than the host expected.  In principle the same thing
could happen with _any_ command.  The host should be prepared for this
and should be able to handle it correctly.  And the host shouldn't
blindly assume that devices will slavishly follow the letter of the
SCSI spec.

We need something much more thorough than just fiddling with
scsi_mode_sense().  One possibility would be to pass a
minimum-response-length argument to scsi_execute_req().  But even that
wouldn't catch all the code paths where this sort of thing could  
happen (although it probably would catch most of them).

This needs someone who is more familiar than I am with the operation of
the SCSI core.
  
Alan Stern

