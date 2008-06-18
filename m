Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYFRAD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYFRAD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 20:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbYFRADU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 20:03:20 -0400
Received: from bar.sig21.net ([88.198.146.85]:59552 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbYFRADT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 20:03:19 -0400
Date: Wed, 18 Jun 2008 02:03:06 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tim Bird <tim.bird@am.sony.com>, Josh Boyer <jwboyer@gmail.com>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the
	kernel
Message-ID: <20080618000306.GA25466@linuxtv.org>
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <485815F6.20507@am.sony.com> <485816B3.3080800@am.sony.com> <20080617202318.GC31224@logfs.org> <20080617163516.2be96400@vader.jdub.homelinux.org> <48583F3B.1090705@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48583F3B.1090705@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.311,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:48:27AM +0200, Stefan Richter wrote:
>>> On Tue, 17 June 2008 12:55:31 -0700, Tim Bird wrote:
> On Tue, 17 Jun 2008 11:28:29 -0700, Tim Bird wrote:
> | One of the main sub-systems that we defer initialization of this
> | way is USB, and this saves quite a bit of time.  (Of course the
> | same, or slightly more CPU cycles are eventually used during
> | bootup time.  But this lets us get to user space quicker so we
> | can start user-visible applications faster.)
>
> What if you don't defer module initialization, but merely device probing?
...
> If you set /sys/bus/foo/drivers_autoprobe to 0 (default is 1), then a  
> /sys/bus/foo/drivers/bar will not be bound to devices.  You can trigger  
> driver--device binding later per device by writing a device's bus ID  
> into /sys/bus/foo/drivers/bar/bind, or by writing into  
> /sys/bus/foo/drivers_probe (I guess; I only used the per-device way so 
> far).

I think the USB bus enumeration can take significant time:
recognize a device is connected, turn on bus power, try
to read descriptors (bus powered devices might be slow to
respond after power up). And this will happen even with
drivers_autoprobe == 0, right?
OTOH I think just calling the module init function when no
devices are present on the bus doesn't need much time.

If you could delay the enumeration it would not be neccessary
to mess with drivers_autoprobe. However, I don't know enough
about USB so I don't know how to do it...


Johannes
