Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZBPVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZBPVrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZBPVrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:47:01 -0500
Received: from kroah.org ([198.145.64.141]:48549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750727AbZBPVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:46:59 -0500
Date: Mon, 16 Feb 2009 12:22:15 -0800
From: Greg KH <greg@kroah.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
Message-ID: <20090216202215.GA6543@kroah.com>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com> <200902160931.34771.oliver@neukum.org> <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com> <20090216161331.GB5008@kroah.com> <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com> <20090216185914.GA6239@kroah.com> <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 02:30:01PM -0500, Mike Murphy wrote:
> On Mon, Feb 16, 2009 at 1:59 PM, Greg KH <greg@kroah.com> wrote:
> >
> > Put it on the logical device, as given to you.
> >
> >> I tried not to break existing functionality.  Additionally, struct
> >> usb_xpad contains two device pointers: one to the actual USB device,
> >> and one to an input device (see source of the in-tree xpad.c). So I
> >> followed your kobject.txt documentation and samples to create a new
> >> object whose sole purpose in life is to expose the sysfs interface,
> >> without interfering with the existing device entries in the driver.
> >> I'm not sure I see a clean way to use a single struct device here....
> >
> > Put it on the input device, which is what is the per-device thing.  It's
> > much simpler than creating a new struct kobject.  You can even create a
> > subdirectory for your attributes if you use an attribute group (which
> > you should be doing anyway, it's much simpler that way.)
> >
> 
> OK, one thing I'm not clear on: is there a clean API for adding
> attributes to an existing struct device, or do I need to "subclass" it
> (the C containment and delegation approach)?

device_create_file()

