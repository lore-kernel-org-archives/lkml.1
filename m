Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYCSWHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYCSWHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbYCSUcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:32:33 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50925 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693AbYCSUcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:32:31 -0400
Date: Tue, 18 Mar 2008 20:12:13 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080318191213.GA2290@eazy.amigager.de>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20080313151403.GA5667@dose.home.local> <Pine.LNX.4.44L0.0803131450370.5744-100000@iolanthe.rowland.org> <20080314071336.GA14550@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314071336.GA14550@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 08:13:36 +0100, Tino Keitel wrote:
> On Thu, Mar 13, 2008 at 14:59:48 -0400, Alan Stern wrote:
> 
> [...]
> 
> > > Well, it seems to be "fixed" by a suspend/resume cycle. Do you have
> > > a
> > > hint how I could try to fix it without suspend/resume, to test if
> > > it is
> > > really the LCD's fault?
> >
> > Testing has to come before fixing -- you can't fix the problem if you
> > don't know which component is at fault.  For all we know, the
> > hardware
> > could be fine and the problem could lie in your application.
> 
> I meant a method other than suspend/resume to fix the broken behaviour,
> so that we get an indication where the problem exactly is.
> 
> >
> > All I can think of for testing is to use usbmon to record the data
> > transfers when those -110 errors come up.
> 
> Well, I still don't have USB_DEBUG or usbmon enabled, but I just got
> that error again. I pulled the power plug from the LCD and replugged
> it, without success. Then I did a suspend/resume cycle, and it worked.

Hi again,

I now have CONFIG_USB_DEBUG enabled, and the bug occurred again. Here
is the kernel log:

2008-03-18_19:08:50.59598 kern.debug: usb usb3: usb auto-resume
2008-03-18_19:08:50.59606 kern.debug: usb usb3: wakeup_rh
2008-03-18_19:08:50.62971 kern.debug: hub 3-0:1.0: hub_resume
2008-03-18_19:08:50.62977 kern.debug: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
2008-03-18_19:08:50.62994 kern.debug: usb usb4: usb auto-resume
2008-03-18_19:08:50.62998 kern.debug: usb usb4: wakeup_rh
2008-03-18_19:08:50.66637 kern.debug: hub 4-0:1.0: hub_resume
2008-03-18_19:08:50.66644 kern.debug: hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
2008-03-18_19:08:50.66662 kern.debug: usb usb2: usb auto-resume
2008-03-18_19:08:50.66666 kern.debug: usb usb2: wakeup_rh
2008-03-18_19:08:50.70342 kern.debug: hub 2-0:1.0: hub_resume
2008-03-18_19:08:50.70348 kern.debug: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
2008-03-18_19:08:51.84851 kern.debug: usb usb3: suspend_rh (auto-stop)
2008-03-18_19:08:51.84858 kern.debug: usb usb4: suspend_rh (auto-stop)
2008-03-18_19:08:51.84862 kern.debug: usb usb2: suspend_rh (auto-stop)
2008-03-18_19:08:53.34640 kern.debug: hub 3-0:1.0: hub_suspend
2008-03-18_19:08:53.34646 kern.debug: usb usb3: bus auto-suspend
2008-03-18_19:08:53.34650 kern.debug: usb usb3: suspend_rh
2008-03-18_19:08:53.34654 kern.debug: hub 4-0:1.0: hub_suspend
2008-03-18_19:08:53.34658 kern.debug: usb usb4: bus auto-suspend
2008-03-18_19:08:53.34662 kern.debug: usb usb4: suspend_rh
2008-03-18_19:08:53.34666 kern.debug: hub 2-0:1.0: hub_suspend
2008-03-18_19:08:53.34670 kern.debug: usb usb2: bus auto-suspend
2008-03-18_19:08:53.34674 kern.debug: usb usb2: suspend_rh
2008-03-18_19:09:00.70316 kern.debug: usb 1-1.3: hidmon timed out on ep0in len=0/9
2008-03-18_19:09:00.70322 kern.debug: usb 1-1.3: usbfs: USBDEVFS_CONTROL failed cmd hidmon rqt 129 rq 6 len 9 ret -110
2008-03-18_19:09:00.70339 kern.debug: usb 1-1.3: manual set_interface for iface 0, alt 0

Regards,
Tino
