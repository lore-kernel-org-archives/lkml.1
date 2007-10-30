Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbXJ3RZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbXJ3RZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXJ3RZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:25:20 -0400
Received: from alnrmhc12.comcast.net ([206.18.177.52]:45301 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXJ3RZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:25:19 -0400
Date: Tue, 30 Oct 2007 10:25:18 -0700
From: "H.J. Lu" <hjl@lucon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: PR Input Devives/2082: PS/2 mouse out of sync after
	switching with KVM switch
Message-ID: <20071030172518.GA25824@lucon.org>
References: <20071030135304.GA24688@lucon.org> <d120d5000710300953kd145c7fg53f4fa4d41fbc9c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710300953kd145c7fg53f4fa4d41fbc9c3@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 12:53:17PM -0400, Dmitry Torokhov wrote:
> Hi,
> 
> On 10/30/07, H.J. Lu <hjl@lucon.org> wrote:
> > The bug report is at
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=2082
> >
> > Problem Description: When switching to another machine with a KVM
> > switch and back, the mouse is out of control, with X.Org.  To recover,
> >  I have to unplug the mouse cable and plug it back.
> >
> > Steps to reproduce: Have a wheel mouse connected and X.Org.  Keyboard,
> > Mouse and Video are connected to a KVM switch. Switch to another
> > machine and back.  You have lost the usage of wheel on mouse.
> >
> > This patch for 2.6.23 tries to reconnect the mouse after KVM switch.
> > It doesn't completely solve the problem. Mouse still got a few random
> > bytes after KVM switch.
> 
> Have you tried psmouse.resync_time=5 option?

My psmouse is kernel builtin. I tried "psmouse.proto=imps" and
it worked. But I don't want to change kernel boot option for each
kernel on each machine behind KVM.

> 
> Any change you coudl do
> 
> echo 1 > /sys/module/i8042/parameters/debug
> 
> before switrching KVM back and forth and send me dmesg?

I will try it when I get home.

> 
> > But it recovers with kernel message:
> >
> > psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, issuing reconnect request.
> >
> > instead of
> >
> > psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, throwing 3 bytes away.
> >
> > and never recovering from it.
> >
> 
> I am hesitant queuing reconnect immediately - if the byte was delayed
> because embedded controller was busy doing something else and we start
> querying mouse at the wrong time we might lose mouse altogether.
> 

As it stands now, my Microsoft wheel mouse isn't usable at all after
KVM switch without my patch. I had to reset mouse cable to get it back.


H.J.
