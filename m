Return-Path: <linux-kernel-owner+w=401wt.eu-S1751251AbYLCJmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbYLCJmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYLCJmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:42:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbYLCJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:42:39 -0500
Date: Wed, 3 Dec 2008 01:42:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303 - pl2303_open - failed submitting interrupt urb, error
 -28
Message-Id: <20081203014208.55dfeb8d.akpm@linux-foundation.org>
In-Reply-To: <20081202131821.GA25217@torres.zugschlus.de>
References: <20081202131821.GA25217@torres.zugschlus.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb)

On Tue, 2 Dec 2008 14:18:21 +0100 Marc Haber <mh+linux-kernel@zugschlus.de> wrote:

> Hi,
> 
> the following applies to a "vanilla" 2.6.27.7 kernel built and running
> on a Debian unstable system.
> 
> To obtain out-of-band access to a number of switches and routers, I
> have a seven-port USB hub to which seven identical USB-to-serial
> adaptors using the PL2303 chip and driver are connected. All seven
> work when only one of them is used at a time.
> 
> Cereal is an application which keeps a process (GNU screen) attached
> to the tty at all times to be able to log what happens on the serial
> port. When I start cereal on all seven ports, I start getting
> "pl2303_open - failed submitting interrupt urb, error -28" errors in
> my syslog:
> 
> Dec  2 14:07:36 alemana kernel: pl2303 ttyUSB2: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:37 alemana kernel: pl2303 ttyUSB5: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:38 alemana kernel: pl2303 ttyUSB6: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:41 alemana kernel: pl2303 ttyUSB2: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:43 alemana kernel: pl2303 ttyUSB5: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:43 alemana kernel: pl2303 ttyUSB6: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:47 alemana kernel: pl2303 ttyUSB2: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:48 alemana kernel: pl2303 ttyUSB5: pl2303_open - failed submitting interrupt urb, error -28
> Dec  2 14:07:49 alemana kernel: pl2303 ttyUSB6: pl2303_open - failed submitting interrupt urb, error -28
> 
> The corresponding ports are not useable in that case.
> 
> When one googles for this error message, one finds a thread from 2006
> with Greg KH commenting. In my case, the error doesn't hose the USB
> subsystem, I can unplug the adapters and plug them in again one and a
> time without a problem, and I can even use the ports that don't throw
> this error message.
> 
> As in the 2006 thread, unloading the EHCI driver (ehci_hcd) solves the
> issue, but is of course not an attractive option as soon as one wants
> to use even a USB stick on the same machine.
> 
> If it helps, I can give out root access to the box in question to
> anybody who is willing to help and debug. Unfortunately, I cannot
> provide any expertise here, I do not even know what an interrupt urb is.
> 
> Any hints will be appreciated.
> 
> Greetings
> Marc

