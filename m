Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYKCLzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYKCLzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYKCLzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:55:04 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:39479 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYKCLzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:55:02 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST /
 unable to handle kernel NULL pointer dereference in sysfs_create_link
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510811030353i72a2a5f6i8869addea1057cfa@mail.gmail.com>
References: <20081028151157.GI11214@vanheusden.com>
	 <ac3eb2510810290525h1579bad8i4836ce1291d9022@mail.gmail.com>
	 <20081029132704.GS11214@vanheusden.com>
	 <ac3eb2510810290749o2dd062b5m7b966d2d25b69714@mail.gmail.com>
	 <20081029152550.GT11214@vanheusden.com>
	 <ac3eb2510810291451u577aa825lc12a7e8fbc213020@mail.gmail.com>
	 <20081030105513.GY11214@vanheusden.com>
	 <ac3eb2510810301606q5ff8e001j239c5108c3db4b6f@mail.gmail.com>
	 <ac3eb2510810301623n6a7256a1td59d3e38a01add4c@mail.gmail.com>
	 <1225445335.7803.1214.camel@twins>
	 <ac3eb2510811030353i72a2a5f6i8869addea1057cfa@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 12:55:35 +0100
Message-Id: <1225713335.7803.1616.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 12:53 +0100, Kay Sievers wrote:
> On Fri, Oct 31, 2008 at 10:28, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2008-10-31 at 00:23 +0100, Kay Sievers wrote:
> >
> >> Peter, it looks like bdi does not work for devices which share a single queue.
> >> If I add:
> >>   --- a/mm/backing-dev.c
> >>  +++ b/mm/backing-dev.c
> >>   @@ -184,6 +184,8 @@ int bdi_register(struct backing_dev_info *bdi,
> >> struct device *parent,
> >>                   goto exit;
> >>           }
> >>
> >>   +       printk("XXXXXXX old bdidev is %p\n", bdi->dev);
> >>   +       printk("XXXXXXX new bdidev is %p\n", dev);
> >>           bdi->dev = dev;
> >>           bdi_debug_register(bdi, dev_name(dev));
> >>
> >> I get:
> >>   $ modprobe floppy
> >>   Floppy drive(s): fd0 is 1.44M, fd1 is 1.44M
> >>   FDC 0 is a S82078B
> >>   XXXXXXX old bdidev is 0000000000000000
> >>   XXXXXXX new bdidev is ffff88001f20cd10
> >>   XXXXXXX old bdidev is ffff88001f20cd10
> >>   XXXXXXX new bdidev is ffff88001f20de30
> >>
> >> which very much looks like bdi will not remove any earlier registered
> >> device, only the last one, right?
> >
> > Sharing a bdi is odd to begin with, let me poke at this a little.
> 
> Yeah, it's odd, but I'm not sure if you want to touch floppy.c. :)
> Any objection to this patch, until you possible fix it differently?
>   http://marc.info/?l=linux-kernel&m=122541569310798&w=4

Non at all, touching floppy.c is dangerous, folks might assume you know
something about it ;-)

