Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZCBXQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZCBXQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZCBXP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:15:57 -0500
Received: from kroah.org ([198.145.64.141]:57807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751873AbZCBXP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:15:56 -0500
Date: Mon, 2 Mar 2009 15:13:43 -0800
From: Greg KH <greg@kroah.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, fweisbec@gmail.com, torvalds@linux-foundation.org
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless
	support and add sysfs interface
Message-ID: <20090302231343.GA31663@kroah.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com> <20090302130425.23cc628d.akpm@linux-foundation.org> <20090302211820.GA21489@kroah.com> <20090302133551.1266f725.akpm@linux-foundation.org> <5aa163d00903021359x3a4693f5tbb7f1e3fec4d88b8@mail.gmail.com> <20090302223916.GA31381@kroah.com> <5aa163d00903021504l1965ecdi3423a43134de10d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5aa163d00903021504l1965ecdi3423a43134de10d0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:04:00PM -0500, Mike Murphy wrote:
> On Mon, Mar 2, 2009 at 5:39 PM, Greg KH <greg@kroah.com> wrote:
> >
> > I tried to create such an interface years ago, and the macro tricks
> > involved ended up being horrible, and in the end, it didn't work.  But
> > if you can come up with something, I'd love to see it.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> I could probably give it a shot, but possibly not until May... once
> the current semester ends. I really need to understand the kernel type
> system -- or at least the types that "should" be exposed to userspace
> -- before thinking about the design too much. Maybe that's the
> question that needs to be asked first: in general, what does a sysfs
> interface into a driver look like? It's certainly flexible enough to
> do a lot, and the existing interfaces allow it to do a lot, but is
> there a simplification that covers some large percentage of cases?

Look at some of the easy things, like integers.  If you could get those
working, the hwmon drivers could be simplified a lot more.

The problem I ran into was that the attribute show/store functions deals
with a "struct device" which you need to cast into some other structure
type, and then determine the offset of the integer you are needing to
access.

Hm, maybe that wouldn't be that hard with 2 offset_of() values, I think
I was only trying to do one, but that was a long time ago...

thanks,

greg k-h
