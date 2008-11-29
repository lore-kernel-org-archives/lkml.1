Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYK2Txu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYK2Txu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYK2Txl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:53:41 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1451 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYK2Txk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:53:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 1/3)
Date: Sat, 29 Nov 2008 20:53:15 +0100
User-Agent: KMail/1.9.9
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>, video4linux-list@redhat.com,
       "Trilok Soni" <soni.trilok@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
References: <200811242309.37489.hverkuil@xs4all.nl> <200811291519.39549.hverkuil@xs4all.nl> <200811291146.44371.david-b@pacbell.net>
In-Reply-To: <200811291146.44371.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811292053.16121.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008 20:46:43 David Brownell wrote:
> On Saturday 29 November 2008, Hans Verkuil wrote:
> > > > +And this to go from an i2c_client to a v4l2_subdev struct:
> > > > +
> > > > +   struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > > > +
> > > > +Finally you need to make a command function to make
> > > > +driver->command() call the right subdev_ops functions:
> > > > +
> > > > +static int
> > > > +subdev_command(struct i2c_client *client, unsigned cmd, void
> > > > *arg) +{
> > > > +   return v4l2_subdev_command(i2c_get_clientdata(client), cmd,
> > > > arg); +}
> > > > +
> > > > +If driver->command is never used then you can leave this out.
> > > > +Eventually the driver->command usage should be removed from
> > > > v4l.
> > >
> > > Should it then be added to the list of features scheduled for
> > > removal?
> >
> > No, driver->command is part of the i2c subsystem and we are not the
> > only users, so it can't be scheduled for removal.
>
> ISTR that the only use of the i2c_driver.command() mechanism
> is for video/DVB driver support.  It's kind of an ugly wart,
> and it'd be good to see such ioctl-ish interfaces vanish.
>
> This came up a while back as part of a "how can we clean up
> the I2C stack" discussion.  So it would be nice if V4L2 wasn't
> effectively adding new reasons (and advice) to use this.

If v4l is indeed the only user, then once all i2c drivers are converted 
to this new sub device API, then command can indeed go away.

Would be nice, but it will probably take a few kernel cycles before we 
are there. It's a lot of work, but very worthwhile in my opinion.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
