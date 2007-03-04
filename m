Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbXCDUld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbXCDUld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 15:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXCDUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 15:41:33 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:16399 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbXCDUlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 15:41:32 -0500
X-IronPort-AV: i="4.14,247,1170651600"; 
   d="scan'208"; a="23512739:sNHT190127497"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Sun, 4 Mar 2007 15:42:25 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <20070304194632.GC30345@flint.arm.linux.org.uk>
In-Reply-To: <20070304194632.GC30345@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703041542.25633.rgetz@blackfin.uclinux.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Mar 2007 20:41:30.0233 (UTC) FILETIME=[7CF00690:01C75E9D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 4 Mar 2007 14:46, Russell King pondered:
> On Thu, Mar 01, 2007 at 07:03:02PM -0500, Mike Frysinger wrote:
>  > the console= bootcmd allows for controlling of the initial state of
>  > flow control by adding/omitting the 'r' suffix ...
>
>  The console command *only* sets the state for the kernel's use of one
>  serial port.  It does not affect any other serial port, so tying
>  random RTS behaviours into that command line option is absolutely
>  silly.

I have one serial port in the system, it shares console, and the 
communications port for the application. (But I guess that is besides the 
point).

When the common serial core initialises the UART, and sees that it has the 
capability to do HW flow control - it enables it, asserting the pin, even if 
I don't want it at that moment in time.

The real issue is that there is some legacy equipment, which gets confused if 
it sees glitches on RTS (which happens today, when serial core init asserts 
RTS, and then the the main application turns it off)...

How do I set the set up the UART, so RTS is avaliable, but not enabled?

Thanks
-Robin
