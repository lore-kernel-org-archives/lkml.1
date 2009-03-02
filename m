Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZCBVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZCBVgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZCBVgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:36:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbZCBVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:36:41 -0500
Date: Mon, 2 Mar 2009 13:35:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: mamurph@cs.clemson.edu, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, fweisbec@gmail.com, torvalds@linux-foundation.org
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless
 support  and add sysfs interface
Message-Id: <20090302133551.1266f725.akpm@linux-foundation.org>
In-Reply-To: <20090302211820.GA21489@kroah.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	<20090302130425.23cc628d.akpm@linux-foundation.org>
	<20090302211820.GA21489@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 13:18:20 -0800
Greg KH <greg@kroah.com> wrote:

> On Mon, Mar 02, 2009 at 01:04:25PM -0800, Andrew Morton wrote:
> > On Sat, 28 Feb 2009 23:53:03 -0500
> > Mike Murphy <mamurph@cs.clemson.edu> wrote:
> > > ...
> > >
> > > +static ssize_t xpad_show_int(struct device *dev, struct device_attribute *attr,
> > > +		char *buf)
> > > +{
> > > +	struct usb_xpad *xpad = to_xpad(dev);
> > > +	int value;
> > > +	if (attr == &dev_attr_rumble_enable)
> > > +		value = xpad->rumble_enable;
> > > +	else if (attr == &dev_attr_controller_number)
> > > +		value = xpad->controller_number;
> > > +	else if (attr == &dev_attr_controller_present)
> > > +		value = xpad->controller_present;
> > > +	else if (attr == &dev_attr_controller_type)
> > > +		value = xpad->controller_type;
> > > +	else if (attr == &dev_attr_left_trigger_full_axis)
> > > +		value = xpad->left_trigger_full_axis;
> > > +	else if (attr == &dev_attr_right_trigger_full_axis)
> > > +		value = xpad->right_trigger_full_axis;
> > > +	else
> > > +		return -EIO;
> > > +	return snprintf(buf, PAGE_SIZE, "%d\n", value);
> > > +}
> > 
> > The code's a bit unusual.  Most drivers don't have all that
> > if-then-else stuff.  They use a separate function for each sysfs file
> > and then they wrap it all up into a macro which emits all the data and
> > code for each file.
> 
> Yes, most don't, but that is because we used to not pass the attribute
> variable to the show/store functions.  It was added so that we could
> reduce the huge numbers of functions needed, to do stuff like this.  The
> hwmon drivers are examples of other drivers that do their show/store
> like this.
> 
> There's nothing wrong with it that I can see.
> 

OK.  I think.

- This approach will require a large number of edits each time an
  attribute is added/removed.

- otoh, removing nasty macros is always nice.

- This approach will generate slower code (which doesn't matter
  here).

- Was it demonstrated that this approach generates less code?


