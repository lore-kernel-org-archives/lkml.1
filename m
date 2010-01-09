Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105Ab0AINnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0AINnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254Ab0AINnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:43:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:42661 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0AINnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:43:18 -0500
Date: Sat, 9 Jan 2010 14:43:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, Pavel Machek <pavel@ucw.cz>,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
In-Reply-To: <5370b38ca0c149470c0e364627c56ee4.squirrel@intranet.cs.nmsu.edu>
Message-ID: <alpine.LNX.2.00.1001091441180.7275@pobox.suse.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>    <45a44e481001071832q40d6f913w2ccf89c4c45a692a@mail.gmail.com> <5370b38ca0c149470c0e364627c56ee4.squirrel@intranet.cs.nmsu.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Rick L. Vinyard, Jr. wrote:

> >> +static ssize_t g13_mled_store(struct device *dev,
> >> +                             struct device_attribute *attr,
> >> +        const char *buf, size_t count)
> >> +{
> >> +       struct hid_device *hdev;
> >> +       int i;
> >> +       unsigned m[4];
> >> +       unsigned mled;
> >> +       ssize_t set_result;
> >> +
> >> +       /* Get the hid associated with the device */
> >> +       hdev = container_of(dev, struct hid_device, dev);
> >> +
> >> +       /* If we have an invalid pointer we'll return ENODATA */
> >> +       if (hdev == NULL || &(hdev->dev) != dev)
> >> +               return -ENODATA;
> >> +
> >> +       i = sscanf(buf, "%u %u %u %u", m, m+1, m+2, m+3);
> >> +       if (!(i == 4 || i == 1)) {
> >> +               printk(KERN_ERR "unrecognized input: %s", buf);
> >> +               return -1;
> >> +       }
> >> +
> >> +       if (i == 1)
> >> +               mled = m[0];
> >> +       else
> >> +               mled = (m[0] ? 1 : 0) | (m[1] ? 2 : 0) |
> >> +                               (m[2] ? 4 : 0) | (m[3] ? 8 : 0);
> >> +
> >> +       set_result = g13_set_mled(hdev, mled);
> >> +
> >> +       if (set_result < 0)
> >> +               return set_result;
> >> +
> >> +       return count;
> >> +}
> >> +
> >> +static DEVICE_ATTR(mled, 0666, g13_mled_show, g13_mled_store);
> >
> > Have you considered the use of the LED class driver as an alternative
> > to introducing these sysfs led controls for the device?
> >
> 
> I did, but this seemed a simpler approach to let user space (such as a
> daemon) manage the leds. In particular this could be used by a user space
> program to map the keys. The MR led could be used to indicate an active
> record mode, etc.

I finally had some time to go through the driver as well (thanks Dmitry 
for beating me with proper review).

Could you be more specific about reasons why you are hesitating to use LED 
subsystem instead of the whole mled stuff in the driver?

I don't see anything that couldn't be achieved using LED class.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
