Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZFKQFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZFKQFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZFKQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:05:04 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48439 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZFKQFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:05:03 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 18:05:52 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906111120260.3040-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906111120260.3040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906111805.53388.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. Juni 2009 17:22:06 schrieb Alan Stern:
> > > Okay, I'll agree to that.  It should be made clear that a device which
> > > is "suspended" according to this definition is not necessarily in a
> > > low-power state.  For example, before powering down the link to a disk
> > > drive you might want the drive's suspend method to flush the drive's
> > > cache, but it wouldn't have to spin the drive down.
> >
> > This precludes handling busses that have low power states that are
> > left automatically. If such links are stacked the management of
> > acceptable latencies cannot be left to the busses.
> > An actual example are the link states of USB 3.0
>
> I don't understand.  Can you explain more fully?

I am talking about the U1 and U2 feature of USB 3.0.

Or abstractly any power saving state that does autoresume in hardware.
In these cases you know that you can enter a powersaving state that
will add X latency.

In terms of user space API we'll probably add a way for user space
to specify how much latency may be added for power management's sake.
If busses are stacked the "latency budget" has to be handled at core level.
If furthermore states that allow IO but with additional latency are ignored,
the budget will be calculated wrongly.

	Regards
		Oliver


