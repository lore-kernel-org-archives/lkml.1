Return-Path: <linux-kernel-owner+w=401wt.eu-S1764749AbYDNSEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764749AbYDNSEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbYDNSEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:04:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52663 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbYDNSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:04:13 -0400
Subject: Re: [PATCH]add private data to struct notifier_bock
From: Peter Zijlstra <peterz@infradead.org>
To: mgross@linux.intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20080414161918.GA4286@linux.intel.com>
References: <20080414161918.GA4286@linux.intel.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 20:04:09 +0200
Message-Id: <1208196249.7164.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 09:19 -0700, mark gross wrote:
> I am working with one of the iwl4965 developers to add pm_qos based
> power management to its power states.  We relalized that the block
> notifier I used in the PM_QOS has no way of passing in any driver device
> instance data.  In this case the developer expected the notification
> call backs to call the iwl4965 notification function with an instance
> pointer to the correct *dev.
> 
> Poking around I've noticed a handful of drivers using notifications that
> seem to keep a list of instance pointers around so it can plug into the
> notification infrastructure.  including : ipmi_msghandler.c adb_hid.c
> md.c ips.c
> 
> As having a registered call back called with a private data pointer set
> up at registration time  is such a common idiom I thought it might be a
> good thing to add a private_data pointer to the struct notifier_block
> and add the interfaces needed to pass the private data as the
> notification chain is processed.

How is:

struct my_device_thingy {
	...
	struct notifier_block my_notifier;
	...
};

int my_device_notifier_call(struct notifier_block *nb, unsigned long val
			    void *data)
{
	struct my_device_thingy *mdt = container_of(nb, struct
				 my_device_thingy, my_notifier);

	...
}

not sufficient?

