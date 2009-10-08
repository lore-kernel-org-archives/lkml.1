Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbZJHNl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbZJHNl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbZJHNl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:41:57 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45949 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbZJHNl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:41:56 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Thu, 8 Oct 2009 15:43:01 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910071720440.4512-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910071720440.4512-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910081543.01933.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Oktober 2009 23:34:12 schrieb Alan Stern:
> I'm losing track of the original point of this thread.  IIRC, the
> problem is how the resume method should know whether or not to submit
> the receive URB(s).  It can't afford to acquire the port mutex because
> it might be called by open or close, at which time the mutex is already
> held.
>
> Other schemes could work, but to me it seems simplest to rely on a flag
> protected by a spinlock.  The flag would mean "URBs are supposed to be
> queued unless we are suspended".  It would be set by open and
> unthrottle, and cleared by close and throttle.

1. Why a spinlock?
2. Can we get by with only one flag?

	Regards
		Oliver


