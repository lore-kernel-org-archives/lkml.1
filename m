Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYH2Rd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYH2Rd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYH2Rdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:33:46 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:37310 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbYH2Rdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:33:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (was: new errors during device detection)
Date: Fri, 29 Aug 2008 19:33:42 +0200
User-Agent: KMail/1.9.9
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0808291209260.4447-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808291209260.4447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291933.43331.elendil@planet.nl>
X-OriginalArrivalTime: 29 Aug 2008 17:33:43.0608 (UTC) FILETIME=[62397B80:01C909FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just replying to one comment now, the rest will need more thought :-)

On Friday 29 August 2008, Alan Stern wrote:
> > Two problems:
> > - CONFIG_USB_DEBUG causes such a huge load of output that it is
> > totally unacceptable to have that enabled permanently for a running
> > system
>
> It shouldn't do that.  Almost all of the extra output occurs when
> devices are plugged in or unplugged; during normal operation there
> should be very few extra messages.  (Depending on what USB drivers you
> use, I suppose...)

Here's a snippet of what I got when I enabled USB debug recently:
[...]
Aug  6 22:06:23 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:06:23 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:06:23 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:06:23 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:06:23 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:06:23 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:06:24 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:06:24 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:06:25 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:06:25 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:06:25 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:06:25 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:06:25 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:06:25 faramir kernel: usb usb2: suspend_rh
Aug  6 22:06:25 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:06:25 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:06:25 faramir kernel: usb usb1: suspend_rh
Aug  6 22:06:28 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:06:28 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:06:28 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:06:28 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:06:28 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:06:28 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:06:28 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:06:28 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:06:28 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:06:28 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:06:28 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:06:28 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:06:29 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:06:29 faramir kernel: usb usb1: suspend_rh (auto-stop)
[...]

AFAIK I have not enabled anything special in userland when it comes to
USB suspension; this is just a standard boot.
I do have CONFIG_USB_SUSPEND enabled though, so maybe one should not do that
when using USB_DEBUG?
