Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYAGB4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYAGB4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYAGB4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:56:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:44828 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYAGB4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:56:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="317000534"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: David Brownell <david-b@pacbell.net>
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080104163101.EDC02115203@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <20080104163101.EDC02115203@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 09:51:32 +0800
Message-Id: <1199670692.3551.5.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 08:31 -0800, David Brownell wrote:
> > This patch changes empty output to "unsupported" in order that a user knows
> > wakeup feature isn't supported by this device when he/she
> > 'cat /sys/devices/.../power/wakeup', please consider to apply, thanks.
> 
> I don't much like this patch.  Not just for the technical reasons
> mentioned in my previous note ... but also because it doesn't update
> the documention at the top, which clearly states that "\n" is
> returned for "temporary or permanent inability to issue wakeup".
> And then it gives the example I gave before ...
> 
> Though I suppose a patch that changes the *entire* userspace interface,
> (which includes its documentation, and all out-of-tree users) would have
> shown more clearly why it wasn't a good idea.  ;)
Really, "\n" should be changed to show that change.
Anyway, "\n" isn't a good indicator for that state. :-)
> 
> 
> > --- a/drivers/base/power/sysfs.c	2008-01-04 16:50:54.000000000 +0800
> > +++ b/drivers/base/power/sysfs.c	2008-01-04 17:14:42.000000000 +0800
> > @@ -49,7 +49,7 @@ wake_show(struct device * dev, struct de
> >  {
> >  	return sprintf(buf, "%s\n", device_can_wakeup(dev)
> >  		? (device_may_wakeup(dev) ? enabled : disabled)
> > -		: "");
> > +		: "unsupported");
> >  }
> >  
> >  static ssize_t
> >
> >

