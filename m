Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbYDNT7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbYDNT7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762586AbYDNT71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:59:27 -0400
Received: from mga07.intel.com ([143.182.124.22]:56600 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761037AbYDNT7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:59:25 -0400
X-ExtLoop1: 1
Date: Mon, 14 Apr 2008 13:05:01 -0700
From: mark gross <mgross@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH]add private data to struct notifier_bock
Message-ID: <20080414200501.GA29123@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080414161918.GA4286@linux.intel.com> <1208196249.7164.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208196249.7164.7.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 14 Apr 2008 19:59:23.0608 (UTC) FILETIME=[0913E580:01C89E6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 08:04:09PM +0200, Peter Zijlstra wrote:
> On Mon, 2008-04-14 at 09:19 -0700, mark gross wrote:
> > I am working with one of the iwl4965 developers to add pm_qos based
> > power management to its power states.  We relalized that the block
> > notifier I used in the PM_QOS has no way of passing in any driver device
> > instance data.  In this case the developer expected the notification
> > call backs to call the iwl4965 notification function with an instance
> > pointer to the correct *dev.
> > 
> > Poking around I've noticed a handful of drivers using notifications that
> > seem to keep a list of instance pointers around so it can plug into the
> > notification infrastructure.  including : ipmi_msghandler.c adb_hid.c
> > md.c ips.c
> > 
> > As having a registered call back called with a private data pointer set
> > up at registration time  is such a common idiom I thought it might be a
> > good thing to add a private_data pointer to the struct notifier_block
> > and add the interfaces needed to pass the private data as the
> > notification chain is processed.
> 
> How is:
> 
> struct my_device_thingy {
> 	...
> 	struct notifier_block my_notifier;
> 	...
> };
> 
> int my_device_notifier_call(struct notifier_block *nb, unsigned long val
> 			    void *data)
> {
> 	struct my_device_thingy *mdt = container_of(nb, struct
> 				 my_device_thingy, my_notifier);
> 
> 	...
> }
> 
> not sufficient?

Because ... um....a.... that would work too.  

Please ignore my last patch.

Thanks!

--mgross

