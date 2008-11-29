Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYK2Tq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYK2Tq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYK2Tqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:46:47 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40165 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751691AbYK2Tqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:46:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u5lTN6HyicKKgaWdx7Ga/3pOAGJdwhrd5IxQC9xF2T+PpcpB9dS4Lk8PojpZ4Lfpp7RPUZop8JzsM34ZSYfj1IjI+Nk61J4XZa4qzlC81lfCibgD2kjy854tYomZEXY5i+JP4hVbVKqVdgoa4dos8uMlyLZYXykvfh5UEmrZTsw=  ;
X-YMail-OSG: cdVt69kVM1lb5f2DPk49EQH6YhwikundktwTiSUJKb7fMxhYlpVZnLj7oGYKuCL.kf2DYwBNQOkwdxZgx8ksVaVXyZDKChOdPWxjaWNcynSCeOCePEf4Mo2uGe2BwzKV95rp_rYeS10EW.2bJVtrzbt94ep.LIoVdVIOgx0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 1/3)
Date: Sat, 29 Nov 2008 11:46:43 -0800
User-Agent: KMail/1.9.10
Cc: video4linux-list@redhat.com, "Trilok Soni" <soni.trilok@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
References: <200811242309.37489.hverkuil@xs4all.nl> <200811290034.44340.laurent.pinchart@skynet.be> <200811291519.39549.hverkuil@xs4all.nl>
In-Reply-To: <200811291519.39549.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811291146.44371.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008, Hans Verkuil wrote:
> > > +And this to go from an i2c_client to a v4l2_subdev struct:
> > > +
> > > +   struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > > +
> > > +Finally you need to make a command function to make
> > > +driver->command() call the right subdev_ops functions:
> > > +
> > > +static int
> > > +subdev_command(struct i2c_client *client, unsigned cmd, void *arg)
> > > +{ 
> > > +   return v4l2_subdev_command(i2c_get_clientdata(client), cmd, arg);
> > > +}
> > > +
> > > +If driver->command is never used then you can leave this out.
> > > +Eventually the driver->command usage should be removed from v4l.
> >
> > Should it then be added to the list of features scheduled for removal?
> 
> No, driver->command is part of the i2c subsystem and we are not the only 
> users, so it can't be scheduled for removal.

ISTR that the only use of the i2c_driver.command() mechanism
is for video/DVB driver support.  It's kind of an ugly wart,
and it'd be good to see such ioctl-ish interfaces vanish.

This came up a while back as part of a "how can we clean up
the I2C stack" discussion.  So it would be nice if V4L2 wasn't
effectively adding new reasons (and advice) to use this.

- Dave

