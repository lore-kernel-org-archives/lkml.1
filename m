Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYAGCVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYAGCVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 21:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYAGCVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 21:21:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:21226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYAGCVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 21:21:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="360199092"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Brownell <david-b@pacbell.net>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200801070257.58884.rjw@sisk.pl>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1199669879.19185.20.camel@yangyi-dev.bj.intel.com>
	 <200801070257.58884.rjw@sisk.pl>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 10:05:45 +0800
Message-Id: <1199671545.3551.16.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-07 at 02:57 +0100, Rafael J. Wysocki wrote:
> On Monday, 7 of January 2008, Yi Yang wrote:
> > On Fri, 2008-01-04 at 08:09 -0800, David Brownell wrote:
> > > > > This patch changes empty output to "unsupported" in order that a user knows
> > > > > wakeup feature isn't supported by this device when he/she
> > > > > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > > > > thanks.
> > > >
> > > > What about simply removing "wakuep" file if wakeup is not supported?
> > > 
> > > It may not *stay* unsupported, so I think changing it in either
> > > of those permanent ways would be confusing/misleading.
> > > 
> > > For example, USB devices have multiple states ... minimally, an
> > > unconfigured state, and a configured state.  Some have multiple
> > > configurations.  Only configured states can be wakeup-capable.
> > > So a given device might have three states, but support wakeup
> > > except in one of them...
> > If so, we can change "unsupported" to "unconfigurable" or "inoperable"
> > which can cover the states "unconfigured", "unsupported" and other
> > unknown states. :-).
> 
> The main problem with your patch is that is changes a documented behavior
> visible by the user space.  That should be done very cautiously.
Which applications are using this interface? if they assume "\n" means
the unconfigurable or unavailable state, this is very fragile.
> 
> Thanks,
> Rafael

