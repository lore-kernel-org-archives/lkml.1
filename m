Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbZHWPNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbZHWPNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbZHWPNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 11:13:23 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:45280 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686AbZHWPNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 11:13:22 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <bugzilla-daemon@bugzilla.kernel.org>
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl on an USB disk
Date: Sun, 23 Aug 2009 12:11:50 -0300
To: Alan Stern <stern@rowland.harvard.edu>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, Alan.

(Sorry if this message seems messed up, but I am not using my regular  
mailer right now, unfortunately).

On 2009-08-22, at 21:17, Alan Stern wrote:

> On Sat, 22 Aug 2009, Rogério Brito wrote:
>
>> The requested trace is attached to this message. Please let me  
>> know if
>> you need more information.
>
> The trace shows that something (presumably smartctl) sends a command
> the drive doesn't understand.  The drive then violates the USB
> mass-storage protocol, sending an invalid response.

Right.

> The kernel waits
> for a proper response but nothing more happens, so after 30 seconds  
> the
> command times out and is aborted and the drive is reset.

I'm not with the kernel sources here (so, I can't check the code),  
but is there any option to be able to log such invalid responses when  
the kernel gets one? Perhaps the verbose USB logging does that?

> The command
> then gets retried, and the same thing happens again.  The retries take
> so long that the kernel complains about smartctl being blocked for  
> more
> than 120 seconds -- that's the reason for the stack dump.

Right.

Geeez, Alan, is there any vendor out there that gets the USB  
implementation according to the specs?

This is the 3rd USB device that I sent you some message about where  
the kernel moans about something that it doesn't understand (I can  
get you the vendor and device ids when I get home).

I will test with some other devices that I have, just to see what  
their response is. :-(

> So the problem has several causes.  One is that the drive is buggy (it
> doesn't respond with an error code in the proper way when it  
> receives a
> command it doesn't understand).  Another is that smartctl is trying to
> send commands in a form the drive can't handle.

That's probably not smartctl, but the user (me) that is telling it to  
use a given command set to check if the USB adapter understands/ 
allows pass-thru of the SMART protocol to the drive.

> Finally, there's the
> problem about all the retries taking too long.

Is there anything that could be done about this?

> Perhaps you can blame the kernel for spending too much time on  
> retries,
> but the other two are the fault of the drive and smartctl.

I understand the p-o-v of the kernel: some devices need a little bit  
more time on a retry, while others don't. There's no way to hardcode  
a once and for all behavior. It seems that an expensive solution to  
this would be to create (yet) another list of blacklisted devices  
(how many lists of quirks do we have in the kernel already---this is  
really causing some bloat, especially for some embedded devices). :-(

OTOH, creating blacklists seem to not be the adequate (let alone  
"right") solution (see the ASUS/it87 monitoring cause) in many  
situations. :-/


Thanks for your always kind messages, Rogério Brito.

