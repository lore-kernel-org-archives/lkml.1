Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXB0AVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXB0AVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXB0AVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:21:41 -0500
Received: from ns.suse.de ([195.135.220.2]:32995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXB0AVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:21:40 -0500
Date: Mon, 26 Feb 2007 16:20:23 -0800
From: Greg KH <greg@kroah.com>
To: Sarah Bailey <saharabeara@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       usb-hacking@svcs.cs.pdx.edu,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usbfs2: Why asynchronous I/O?
Message-ID: <20070227002023.GA13099@kroah.com>
References: <20070225085755.GA4886@localdomain> <200702250853.03851.david-b@pacbell.net> <20070225173302.GA12190@comsec.com> <20070225085755.GA4886@localdomain> <200702250853.03851.david-b@pacbell.net> <Pine.LNX.4.44L0.0702251147500.25265-100000@netrider.rowland.org> <20070226085431.GA16499@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226085431.GA16499@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 12:54:31AM -0800, Sarah Bailey wrote:
> Yes, a sane interface to the USRP was one of the main motivations for
> the new USB filesystem.  It remains to be seen whether we need a
> non-standard interface like io_submit, or whether threads with blocking
> I/O is fast enough and has the right semantics.

So, just for the sake of argument, how would one submit multiple urbs to
a single endpoint to ensure that the pipe is full with blocking I/O?
Would they have to:

  - open endpoint
  - create thread 1
  - create thread 2
  - create thread 3
  - create thread 4
  - send first packet to thread 1 to have it write to the endpoint.
  - send next packet to thread 2 to have it write to the endpoint.
  ...  and so on?

This seems very "hard" on userspace for something as simple as "I want
to send this data stream to the USB device as fast as is possible".

With async I/O you can just:
  - open endpoint
  - send first packet to endpoint with async write
  - send second packet to endpoint
  ... and so on


I'm all for using threads in userspace, as they are good ideas and very
powerful, but for a single data stream, they really seem like a complex
solution.

thanks,

greg k-h
