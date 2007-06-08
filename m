Return-Path: <linux-kernel-owner+w=401wt.eu-S1031772AbXFHSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031772AbXFHSsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031539AbXFHSru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:47:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939216AbXFHSrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:47:48 -0400
Date: Fri, 8 Jun 2007 11:48:35 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: blank filenames in /sys/modules, kernel 2.6.21
Message-Id: <20070608114835.7a5af390.zaitcev@redhat.com>
In-Reply-To: <20070608183232.GA12967@kroah.com>
References: <46699945.6020106@redhat.com>
	<Pine.LNX.4.64.0706081402510.7805@localhost.localdomain>
	<20070608183232.GA12967@kroah.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 11:32:32 -0700, Greg KH <greg@kroah.com> wrote:

> >   and from drivers/usb/core/usb.c:
> > 
> > /* format to disable USB on kernel command line is: nousb */
> > __module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);

> Pete added that back in December of 2005 (git-blame rocks...).  So what
> has changed recently to cause this to do different things in sysfs?
> 
> Robert, what do you suggest we change this usage to look like?

Aww. I thought it was a nice patch, but my foresight was inadequate.

The problem I tried to fix was related to strncmp used in the code which
supported __setup(). Our installer, Anaconda, recognizes both "nousb" and
"nousbstorage" - in theory. In practice, passing "nousbstorage" switched
USB completely off because of improper strncmp(). If we back out my patch,
this problem is going to reoccur.

We might want to ask Jeremy Katz if "nousbstorage" is even used anymore,
then revert all this if not. Or, we can add a name somehow and live
with it visible in sysfs...

-- Pete
