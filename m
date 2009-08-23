Return-Path: <linux-kernel-owner+w=401wt.eu-S933582AbZHWSWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbZHWSWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933468AbZHWSWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:22:41 -0400
Received: from smtp.infotech.no ([82.134.31.41]:58062 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbZHWSWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:22:40 -0400
Message-ID: <4A9188EA.2080903@interlog.com>
Date: Sun, 23 Aug 2009 14:22:34 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
References: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org> <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
In-Reply-To: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote:
> Hi again, Alan.
> 
> (Sorry if this message seems messed up, but I am not using my regular 
> mailer right now, unfortunately).
> 
> On 2009-08-22, at 21:17, Alan Stern wrote:
> 
>> On Sat, 22 Aug 2009, Rogério Brito wrote:
>>
>>> The requested trace is attached to this message. Please let me know if
>>> you need more information.
>>
>> The trace shows that something (presumably smartctl) sends a command
>> the drive doesn't understand.  The drive then violates the USB
>> mass-storage protocol, sending an invalid response.
> 
> Right.
> 
>> The kernel waits
>> for a proper response but nothing more happens, so after 30 seconds the
>> command times out and is aborted and the drive is reset.
> 
> I'm not with the kernel sources here (so, I can't check the code), but 
> is there any option to be able to log such invalid responses when the 
> kernel gets one? Perhaps the verbose USB logging does that?
> 
>> The command
>> then gets retried, and the same thing happens again.  The retries take
>> so long that the kernel complains about smartctl being blocked for more
>> than 120 seconds -- that's the reason for the stack dump.
> 
> Right.
> 
> Geeez, Alan, is there any vendor out there that gets the USB 
> implementation according to the specs?

The fact that you invoked:
   smartctl -d usbcypress -a /dev/sda

means that the cypress chip does not comply with SAT.
To find out what commands are being sent (via the SG_IO
ioctl I presume) by smartctl please try adding:
   '-r ioctl,3'
to the above invocation.


Doug Gilbert
