Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZJHLgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZJHLgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbZJHLgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:36:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50174 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbZJHLgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:36:21 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Thu, 8 Oct 2009 13:37:09 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910071320120.3051-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910071320120.3051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910081337.10275.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Oktober 2009 19:23:59 schrieb Alan Stern:
> > We can take the port->mutex lock in the throttle/unthrottle methods as
> > far as I can see - there are no obvious problem cases. We do call
> > ->throttle and ->unthrottle from the ldisc open but this occurs outside
> > of any call to the tty driver open/close method so I don't see any
> > deadlock.
> >
> > It adds an ordering of termios lock before port mutex when taking both
> > but that's not a problem and really implicit in the structure of the code
> > anyway.
>
> Does this imply that unthrottle should try to autoresume?  There does
> appear to be a potential race between unthrottle and autosuspend.

The race exists. But I don't think unthrottle should autoresume.
It would be better to just set a flag and defer this to resume.
If the device supports remote wakeup there'll be no need to autoresume,
if not, throttle/unthrottle are too rare to justify the complexity.

	Regards
		Oliver

