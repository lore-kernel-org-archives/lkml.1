Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0BRE1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:27:13 -0500
Received: from kroah.org ([198.145.64.141]:48072 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab0BRE1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:27:10 -0500
Date: Wed, 17 Feb 2010 20:27:11 -0800
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100218042711.GC11649@kroah.com>
References: <20100216173926.b7a4d25c.sfr@canb.auug.org.au> <20100216100100.55f5922f@hyperion.delvare> <20100217045616.GA2923@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217045616.GA2923@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 08:56:16PM -0800, Greg KH wrote:
> On Tue, Feb 16, 2010 at 10:01:00AM +0100, Jean Delvare wrote:
> > Hi Stephen,
> > 
> > On Tue, 16 Feb 2010 17:39:26 +1100, Stephen Rothwell wrote:
> > > After merging the driver-core tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > drivers/i2c/i2c-smbus.c:58: error: 'struct device' has no member named 'sem'
> > > drivers/i2c/i2c-smbus.c:66: error: 'struct device' has no member named 'sem'
> > > 
> > > Caused by commit 0819a881db29059d113fc5f019f7c489dea5937d from the
> > > driver-core tree interacting with commit
> > > 38f1e8aedf0a238d56fbcd3660fc140b50dbc89a ("i2c: Add SMBus alert support")
> > > from the i2c tree.
> > > 
> > > I have applied the following patch for today and will use it as a merge
> > > fixup for the driver-core tree while necessary.
> > 
> > Thanks for the heads up and the fix. Greg, is there an API I am
> > supposed to use instead of accessing the device's semaphore/mutex
> > directly?
> 
> I will create a device_lock() and device_unlock() api to solve this
> problem.  That will fix the issue for when we try to change this from a
> semaphore to a mutex (like the patch in linux-next does), but we need to
> revert it due to lockdep issues that are being reported incorrectly.
> 
> For now, your code is fine, I'll change over your code in the .34 tree
> when the new api goes in.  I'll also drop this mutex patch in a day as
> well, because of the problems it has caused.

The functions are now in my tree, I'll fix up your code in the .34 merge
period.

thanks,

greg k-h
