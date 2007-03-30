Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXC3T4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXC3T4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXC3T4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:56:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbXC3T43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:56:29 -0400
Date: Fri, 30 Mar 2007 12:54:37 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com, zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070330125437.b3229471.zaitcev@redhat.com>
In-Reply-To: <d120d5000703301114r420a9604i34b6a015e6bad285@mail.gmail.com>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<d120d5000703301114r420a9604i34b6a015e6bad285@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 14:14:20 -0400, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> > I didn't like a) layering violation, and b) that they defeat filtering
> > unconditionally. Why have any filtering then?
> >
> > Instead, I propose for USB HID driver to reset NumLock on probe. Like this:
> >
> > --- a/drivers/usb/input/hid-core.c

> This is fine and that's what we do in atkbd probe but maybe we should
> move that in input core and reset leds as part of
> input_register_device()?

Sure, as long as it works. I think (as much as I understand), that we
already attempt to do this indirectly. input_register_device invokes
->start handlers, and the kbd_start attempts to reset LEDs, but fails
because of the state filtering.

-- Pete
