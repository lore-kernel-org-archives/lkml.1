Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZHUOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZHUOCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZHUOCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:02:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43303 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754643AbZHUOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:02:51 -0400
Date: Fri, 21 Aug 2009 10:02:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090820225819.14c70306@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908210958100.2912-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Alan Cox wrote:

> So the tty layer always went that way so that the awkward cases around an
> opening failing with a hangup just go away. For the normal drivers which
> basically do
> 
> open:
> 	tty layer open work
> 		open hardware and set ASYNCB_INITIALIZED
> 	block for carrier
> 
> close:
> 	if (!hung_up) {
> 		if initialized
> 			shutdown()
> 	}
> 
> the USB layer works really hard to be completely different (in part
> because the old code simply didn't implement open semantics properly or
> hangup correctly - hence things like mgetty fail on them).
> 
> The later patches I was working on were trying to get USB serial to the
> point where the model was that drv->open/drv->close were the hardware
> init/shutdown and did indeed get called in nice matching open/close pairs
> and not re-entered or called unserialized.

That is indeed the best approach.  How much is still needed to make it 
work?

> Nice spot on the ASYNC v ASYNCB bug Alan btw

Hah!  Crashing with a big oops was a pretty strong hint that something
was wrong.  The tricky part was grovelling through the disassembly 
listing and figuring out why the offsets were so huge.  :-)

Alan Stern

