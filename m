Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZBQE5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZBQE5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 23:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZBQE5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 23:57:35 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:62731 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZBQE5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 23:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <20090217031813.GD8343@kroah.com>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
	 <200902160931.34771.oliver@neukum.org>
	 <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
	 <20090216161331.GB5008@kroah.com>
	 <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com>
	 <20090216185914.GA6239@kroah.com>
	 <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com>
	 <20090216202215.GA6543@kroah.com>
	 <5aa163d00902161853x27d98a83l3c2c02abe651fe1e@mail.gmail.com>
	 <20090217031813.GD8343@kroah.com>
Date: Mon, 16 Feb 2009 23:57:31 -0500
X-Google-Sender-Auth: 55b00c6b3c382f51
Message-ID: <5aa163d00902162057l106c001bo519a5241c79b5e96@mail.gmail.com>
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 10:18 PM, Greg KH <greg@kroah.com> wrote:
>
> input_set_drvdata() and input_get_drvdata() is what you are looking for.
>

Thanks! That solved the problem at least as far as getting the entries
to show up in sysfs... though somehow now I'm having problems with the
I/O buffers, and a cat of the sysfs file shows no output (not even a
blank line). I added a couple printk's to one of the routines, and the
values are being read correctly from the data structure, but no
working I/O (cannot set the values either, per printk results). The
dmesg output shows the printk results, so the functions are getting
called. Even the count from sprintf is correct, and the resulting
buffer looks like it should... though with the extra blank line I
added in the last printk:

static ssize_t xpad_show_dead_zone(struct device *dev, char *buf)
{
	struct usb_xpad *xpad = to_xpad(dev);
	int count;
	printk(KERN_INFO "Dead zone is %d\n", xpad->dead_zone);
	count = sprintf(buf, "%d\n", xpad->dead_zone);
	printk(KERN_INFO "Count is %d\n", count);
	printk(KERN_INFO "Buffer is %s\n", buf);
	return count;
}

Unless that is some common error that is obvious from its description,
I will have to chase the bug down tomorrow or Wednesday. It's getting
a bit late here.

Thanks,
Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
