Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZCBVUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZCBVUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZCBVUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:20:31 -0500
Received: from kroah.org ([198.145.64.141]:49973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654AbZCBVUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:20:30 -0500
Date: Mon, 2 Mar 2009 13:18:20 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Murphy <mamurph@cs.clemson.edu>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, fweisbec@gmail.com, torvalds@linux-foundation.org
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless
	support  and add sysfs interface
Message-ID: <20090302211820.GA21489@kroah.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com> <20090302130425.23cc628d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302130425.23cc628d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 01:04:25PM -0800, Andrew Morton wrote:
> On Sat, 28 Feb 2009 23:53:03 -0500
> Mike Murphy <mamurph@cs.clemson.edu> wrote:
> > ...
> >
> > +static ssize_t xpad_show_int(struct device *dev, struct device_attribute *attr,
> > +		char *buf)
> > +{
> > +	struct usb_xpad *xpad = to_xpad(dev);
> > +	int value;
> > +	if (attr == &dev_attr_rumble_enable)
> > +		value = xpad->rumble_enable;
> > +	else if (attr == &dev_attr_controller_number)
> > +		value = xpad->controller_number;
> > +	else if (attr == &dev_attr_controller_present)
> > +		value = xpad->controller_present;
> > +	else if (attr == &dev_attr_controller_type)
> > +		value = xpad->controller_type;
> > +	else if (attr == &dev_attr_left_trigger_full_axis)
> > +		value = xpad->left_trigger_full_axis;
> > +	else if (attr == &dev_attr_right_trigger_full_axis)
> > +		value = xpad->right_trigger_full_axis;
> > +	else
> > +		return -EIO;
> > +	return snprintf(buf, PAGE_SIZE, "%d\n", value);
> > +}
> 
> The code's a bit unusual.  Most drivers don't have all that
> if-then-else stuff.  They use a separate function for each sysfs file
> and then they wrap it all up into a macro which emits all the data and
> code for each file.

Yes, most don't, but that is because we used to not pass the attribute
variable to the show/store functions.  It was added so that we could
reduce the huge numbers of functions needed, to do stuff like this.  The
hwmon drivers are examples of other drivers that do their show/store
like this.

There's nothing wrong with it that I can see.

thanks,

greg k-h
