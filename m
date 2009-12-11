Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZLKFMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZLKFMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZLKFMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:12:03 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:24939
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbZLKFMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:12:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoABAHZjIUt8qNxK/2dsb2JhbAAI10CEKwQ
X-IronPort-AV: E=Sophos;i="4.47,379,1257091200"; 
   d="scan'208";a="489169558"
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
 gpioN for device names
From: Ben Nizette <bn@niasdigital.com>
To: Greg KH <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, Artem.Bityutskiy@nokia.com,
       akpm@linux-foundation.org
In-Reply-To: <20091211034711.GA2773@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <200912101939.30446.david-b@pacbell.net>  <20091211034711.GA2773@suse.de>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 16:12:37 +1100
Message-Id: <1260508357.12048.217.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 19:47 -0800, Greg KH wrote:
> On Thu, Dec 10, 2009 at 07:39:30PM -0800, David Brownell wrote:
> > On Wednesday 09 December 2009, Jani Nikula wrote:
> > > While the device names are now unique again, collisions in chip->names
> > > will still prevent duplicates from being exported to sysfs.
> > 
> > That's why I was never a real fan of chip->names...

Yea, poor idea indeed.

> > 
> > IMO a "good" solution in this space needs to accept that
> > those names are not going to be globally unique ... but
> > that they'll be unique within some context, of necessity.
> > 
> > If Greg doesn't want to see those names under classes,
> > so be it ... but where should they then appear?
> 
> As a sysfs file within the device directory called 'name'?  Then just
> grep through the tree to find the right device, that also handles
> duplicates just fine, right?

Well it bunts the handling of duplicates to who ever is grepping but
yea, sounds good.  The user script can sanity-check it's results against
the controlling gpio-chip if need be.  In fact, maybe symlink from
gpioN/chip back to gpio-chipY could be useful?  A bit redundant though,
as you can check using the number ranges..

In fact I thought I had a patch to create /sys/class/gpio/gpioN/name at
some stage..  Can't find it though, oh well.

	--Ben.


