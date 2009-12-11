Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZLKDe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZLKDe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZLKDe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:34:57 -0500
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:29520 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405AbZLKDe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:34:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CaTAf48mcfl/dlInCPDIg+U97eiQD601k2jQO9oop4WnZLJ+lQYF1JTH7sWFNDjEzgdkGMN2lviloYuZNSaf3ejNAYOI9hZqi24jygYdekb4AR0qtITrSvZSHub4llV/OuxR7NAdmlDJglJYV6cb7axWu4ftPS74eIPkehkcy4c=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: WBb_Xy8VM1kRourZnHZ1xksW2Z28lmGeMaNoC_hzwcVbPZp.wYkC1Mq8UB8FsPJfI3yvcgo5tc7AwnaZDYFhqMQAAlidWyN_8SiWTuIZ0HCH_qfXOa.HYXg6_IB2qiGA4uDjMKUhwwMJfL_2mfV6A6nqsPaP9PI5Fb5zC9QtwfwO3dd4iOlZqFHfA7fyMXDSWRD9JdsahibQ0sWld3xeKDFxGP49q2jvH_rdrbgHigc1IT6D.6MDBulGxJMIntv.
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under gpio class directory
Date: Thu, 10 Dec 2009 19:35:01 -0800
User-Agent: KMail/1.9.10
Cc: ext Greg KH <gregkh@suse.de>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem \(Nokia-D/Helsinki\)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <20091210024834.GB20410@suse.de> <1260455537.25352.1762.camel@jani-desktop>
In-Reply-To: <1260455537.25352.1762.camel@jani-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200912101935.01974.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009, Jani Nikula wrote:
> GPIOs can be exported to gpiolib sysfs at /sys/class/gpio/ like this:
> 
> # ls -l /sys/class/gpio/
> --w-------    1 root     0            4096 Jan  1 00:00 export
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio25 -> ../../devices/virtual/gpio/gpio25
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio38 -> ../../devices/virtual/gpio/gpio38
> ...

Hmm, ISTR they don't always appear as "virtual" ... though that's
pretty much irrelevant to the larger point you're making.  Even
when there are real device nodes for the gpio chips parenting any
given GPIOs, they end up in fairly un-useful parts of the device
tree (in terms of being related to something more significant than
the random wires that were handy to the hardware designer).


> The GPIO lines may and do change from board revision to another. For
> example a power button's GPIO number might be 25 in board rev 1.0 but 66
> in board rev 1.1.
> 
> We want to assign symbolic names to GPIO lines and hide the numbering
> changes from userspace, because it is very painful to amend userspace
> for every board revision.

Related:  these are part of what one might call "composite devices",
which are crafted using a component from this subsystem, one from that,
a few from over there, and so on.  They don't properly belong in any
single location in the device tree.  Some level of symlinking seems
inevitable.

And no, a full fledged chardev node is inappropriate so I don't
see udev as able to help out.

