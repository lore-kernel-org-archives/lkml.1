Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbXFAQXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbXFAQXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758906AbXFAQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:23:39 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:57694 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXFAQXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:23:38 -0400
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Purdie <rpurdie@openedhand.com>
To: Richard Hughes <hughsient@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <1180713579.12843.8.camel@localhost.localdomain>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 17:23:24 +0100
Message-Id: <1180715004.6390.169.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 16:59 +0100, Richard Hughes wrote:
> On Fri, 2007-06-01 at 16:43 +0100, Richard Purdie wrote:
> > I accept this is basically out of my hands now. Greg/Kay have the
> > appropriate emails and if they'll let me know which approach they want
> > to take, I'll apply an appropriate patch. I'd suggest not applying this
> > patch directly as it introduces a race in the error path it alters.
> 
> Sure, I really wanted to convert the class to struct device (which I'm
> more familiar with) but just tried to do minimal changes. What changes
> need to be made to avoid a race? Thanks.

It has nothing to do with the struct device vs. class devices, you need
to think more carefully about the placement of the list_del().

My other concerns with this patch are that it exports incorrect
information on spitz (which I had warned about and I will get bug
reports about) and that "description" is not really a suitable name for
a sysfs attribute, "function" might give a better idea of what it
represents to developers.

I still question whether either colour or function properties are
actually particularly useful to userspace other than for naming purposes
which is why they were part of the device name.

Anyhow, I'm trying not to say too much more as it will just go in
circles. I'll await a reply from Greg.

Regards,

Richard


