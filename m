Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbYBLP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbYBLP3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762388AbYBLP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:29:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52188 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762204AbYBLP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:29:26 -0500
Date: Tue, 12 Feb 2008 07:27:15 -0800
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (adm1026) Properly terminate sysfs groups (Was:
	panic about sysfs with adm1026)
Message-ID: <20080212152715.GB19441@kroah.com>
References: <86802c440802092355l7393fe07gfbd021e9cef66181@mail.gmail.com> <20080210171004.GB25353@kroah.com> <20080210190115.2ebd4124@hyperion.delvare> <86802c440802111539w7eeb84dcu97103733364f7a7b@mail.gmail.com> <20080212092722.32c30eac@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212092722.32c30eac@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:27:22AM +0100, Jean Delvare wrote:
> Hi Yinghai,
> 
> On Mon, 11 Feb 2008 15:39:39 -0800, Yinghai Lu wrote:
> > On Feb 10, 2008 10:01 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > > Yeah, I am an idiot. In 5b34dbcd88251508d02e48ad9b0f9b8232a13ee0 I
> > > introduced two new sysfs file groups but forgot to NULL-terminate them.
> > > Sorry about that, here's the fix:
> > >
> > > * * * * *
> > >
> > > The missing NULL at the end of two sysfs file groups causes a kernel
> > > crash when calling sysfs_create_group().
> > >
> > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > ---
> > >  drivers/hwmon/adm1026.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > --- linux-2.6.25-rc0.orig/drivers/hwmon/adm1026.c       2008-02-10 11:21:54.000000000 +0100
> > > +++ linux-2.6.25-rc0/drivers/hwmon/adm1026.c    2008-02-10 18:51:00.000000000 +0100
> > > @@ -1624,6 +1624,7 @@ static struct attribute *adm1026_attribu
> > >         &dev_attr_temp3_crit_enable.attr,
> > >         &dev_attr_temp3_auto_point1_pwm.attr,
> > >         &dev_attr_temp3_auto_point2_pwm.attr,
> > > +       NULL
> > >  };
> > >
> > >  static const struct attribute_group adm1026_group_temp3 = {
> > > @@ -1639,6 +1640,7 @@ static struct attribute *adm1026_attribu
> > >         &sensor_dev_attr_in9_max.dev_attr.attr,
> > >         &sensor_dev_attr_in9_min.dev_attr.attr,
> > >         &sensor_dev_attr_in9_alarm.dev_attr.attr,
> > > +       NULL
> > >  };
> > >
> > >  static const struct attribute_group adm1026_group_in8_9 = {
> > >
> > > * * * * *
> > 
> > it works. Thanks
> 
> Great, thanks. Mark, please include this patch in your next patch to
> Linus for 2.6.25.

Can someone send it to stable@kernel.org also when it goes into Linus's
tree, as it looks like a pretty bad thing :)

thanks,

greg k-h
