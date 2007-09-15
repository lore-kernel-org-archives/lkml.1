Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXIOIFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXIOIFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXIOIFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:05:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbXIOIFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:05:32 -0400
Date: Sat, 15 Sep 2007 01:05:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Greg KH" <gregkh@suse.de>, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
Message-Id: <20070915010519.34bcb9ae.akpm@linux-foundation.org>
In-Reply-To: <d120d5000709100624s4fd7e68djf8654a4d591cbb5d@mail.gmail.com>
References: <46E2D712.1010402@gmail.com>
	<3ae72650709091603o57c976d1q8a1b5492ef041186@mail.gmail.com>
	<200709100128.48595.dtor@insightbb.com>
	<20070910054448.GA3515@suse.de>
	<d120d5000709100624s4fd7e68djf8654a4d591cbb5d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 09:24:04 -0400 "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> On 9/10/07, Greg KH <gregkh@suse.de> wrote:
> > On Mon, Sep 10, 2007 at 01:28:47AM -0400, Dmitry Torokhov wrote:
> > > On Sunday 09 September 2007 19:03, Kay Sievers wrote:
> > > > On 9/8/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
> > > > >
> > > > > However, the change that broke id_path of udev is that
> > > > > /sys/class/input/event5/device is now a symlink to the inputX directory
> > > > > instead of being the same as the device symlink in inputX directory,
> > > > > i.e. to ../../../devices/platform/pcspkr in this case.
> > > > >
> > > > > Udev id_path uses that directory to construct the ID_PATH variable.
> > > > > Should the sysfs structure be reverted or should udev be adapted to
> > > > > handle traversing /device symlink twice? I think the former, as there
> > > > > should be considerably more time to adapt udev for coming changes in sysfs.
> > > >
> > > > Udev's path_id script is too dumb to follow the "device" link of
> > > > stacked class devices in the CONFIG_SYSFS_DEPRECATED=y layout. Does
> > > > this change fix it for you?
> > > >   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff_plain;h=b1ac36ff5e3756cefc79967a26280056da31bf6f
> > > >
> > >
> > > Hmm, fixing udev is good but users will not get the change in time. I think we
> > > need to adjust SYSFS_DEPRECATED code to produce old results. Something like the
> > > patch below. I wonder what Greg would think...
> >
> > Hm, I don't understand.  Didn't the original conversion of the input
> > layer by Kay not have this kind of problem?  What did your changes do
> > differently to cause this driver core change to be needed?
> >
> 
> If I understand it correctly Kay's convesion had the same issue. With
> class devices "device" link points to class_dev->device instead of
> class_dev->parent. If you want to keep compatibility with old sysfs
> layout when moving from class devices to regular devices then you need
> to "skip" couple of parents till you get to "real" device. This only
> matters for input because this was the only subsystem with class
> devices stacked.
> 

<wonders where the rest of this thread went to>

Did this userspace-visible post-2.6.22 regression get fixed?

