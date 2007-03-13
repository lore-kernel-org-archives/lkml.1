Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbXCMQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbXCMQBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXCMQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:01:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38102 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753291AbXCMQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:01:42 -0400
Date: Tue, 13 Mar 2007 12:01:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45F5D4E7.7040209@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703131155050.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Jiri Slaby wrote:

> Alan, sorry for the previous bad post, I mismatched 2 files. This is 
> hopefully correct.
> 
> > thanks. Could you also please redo the test with the offending uhci patch 
> > reverted and send the output of a working situation?
> 
> - BAD kernel:
> 
> USBMON output:
> d28dba40 1882513063 C Ii:008:01 0 8 = 00005300 00000000
> d28dba40 1882513090 S Ii:008:01 -115 8 <
> f7b31340 1882515363 S Co:008:00 s 21 09 0200 0000 0001 1 = 00
> f7b31340 1882517065 C Co:008:00 0 1 >

> *******************************************************************
> - GOOD kernel (reverted):
> 
> USBMON output:
> f7b31ec0 2545055172 C Ii:004:01 0 8 = 00005300 00000000
> f7b31ec0 2545055198 S Ii:004:01 -115 8 <
> f588aec0 2545055215 S Co:004:00 s 21 09 0200 0000 0001 1 = 01
> f588aec0 2545057168 C Co:004:00 0 1 >
> f7b31ec0 2545135153 C Ii:004:01 0 8 = 00000000 00000000
> f7b31ec0 2545135166 S Ii:004:01 -115 8 <

I don't see anything in the UHCI snapshots to explain the difference in 
behavior.  One thing that stands out is the other, low-speed device (a 
mouse?) -- in the bad kernel dump its driver was running and in the good 
kernel dump its driver wasn't.

But that shouldn't have affected the result.  In fact, nothing in your
data was significant.  It could be that the problem occurs earlier, at the
time when the keyboard is first plugged in.

Can you get another pair of usbmon logs, starting from before you plug in
the keyboard?  Don't bother with the UHCI snapshots for now.

Alan Stern


