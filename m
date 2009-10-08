Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbZJHP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbZJHP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbZJHP0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:26:23 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38830 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbZJHP0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:26:22 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Thu, 8 Oct 2009 17:27:11 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910081054300.2986-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910081054300.2986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910081727.11745.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. Oktober 2009 16:58:39 schrieb Alan Stern:
> On Thu, 8 Oct 2009, Oliver Neukum wrote:
> > Am Mittwoch, 7. Oktober 2009 23:34:12 schrieb Alan Stern:

> > > Other schemes could work, but to me it seems simplest to rely on a flag
> > > protected by a spinlock.  The flag would mean "URBs are supposed to be
> > > queued unless we are suspended".  It would be set by open and
> > > unthrottle, and cleared by close and throttle.
> >
> > 1. Why a spinlock?
>
> Because the amount of work involved seems too small for a mutex.  But
> you could use a mutex if you wanted, since everything occurs in process
> context.

We have to submit URBs under that lock.

> > 2. Can we get by with only one flag?
>
> If all you want to do is answer a single question ("Should URBs be
> submitted") then a single flag should be all you need.  Why, do you
> think more information will be necessary?  You can always add more.

We have at least three reasons URBs should not be submitted.
- closure
- throttling
- suspension
Resume() should not submit if either closure or throttling are active,
neither should unthrottle() resubmit if closure or suspension are active.

	Regards
		Oliver

