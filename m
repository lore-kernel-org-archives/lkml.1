Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZBQS2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZBQS2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZBQS1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:27:51 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:46053 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZBQS1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:27:50 -0500
MIME-Version: 1.0
In-Reply-To: <5aa163d00902162057l106c001bo519a5241c79b5e96@mail.gmail.com>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
	 <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
	 <20090216161331.GB5008@kroah.com>
	 <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com>
	 <20090216185914.GA6239@kroah.com>
	 <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com>
	 <20090216202215.GA6543@kroah.com>
	 <5aa163d00902161853x27d98a83l3c2c02abe651fe1e@mail.gmail.com>
	 <20090217031813.GD8343@kroah.com>
	 <5aa163d00902162057l106c001bo519a5241c79b5e96@mail.gmail.com>
Date: Tue, 17 Feb 2009 13:27:48 -0500
X-Google-Sender-Auth: e7e528c203f4008e
Message-ID: <5aa163d00902171027o139ba751r8103f948f3f492bb@mail.gmail.com>
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

On Mon, Feb 16, 2009 at 11:57 PM, Mike Murphy <mamurph@cs.clemson.edu> wrote:
> Unless that is some common error that is obvious from its description,
> I will have to chase the bug down tomorrow or Wednesday. It's getting
> a bit late here.
>

Fixed... the function signature was wrong. Should have been:

static ssize_t xpad_show_dead_zone(struct device *dev, struct
device_attribute *attr, char *buf)

Incidentally, both Documentation/driver-model/device.txt and
Documentation/filesystems/sysfs.txt appear to be wrong. The former
defines the device attribute structure as:

struct device_attribute {
        struct attribute        attr;
        ssize_t (*show)(struct device * dev, char * buf, size_t count,
loff_t off);
        ssize_t (*store)(struct device * dev, const char * buf, size_t
count, loff_t off);
};

while the latter (that I followed last night) defines it as:

struct device_attribute {
        struct attribute        attr;
        ssize_t (*show)(struct device * dev, char * buf);
        ssize_t (*store)(struct device * dev, const char * buf);
};

I finally got the correct one out of include/linux/device.h:

struct device_attribute {
	struct attribute	attr;
	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
			char *buf);
	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
			 const char *buf, size_t count);
};

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
