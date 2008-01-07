Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYAGQnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYAGQnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYAGQnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:43:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37298 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbYAGQne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:43:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: yi.y.yang@intel.com
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to  "unsupported" if wakeup feature isn't supported by a device
Date: Mon, 7 Jan 2008 17:46:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Brownell <david-b@pacbell.net>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <200801070257.58884.rjw@sisk.pl> <1199671545.3551.16.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1199671545.3551.16.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071746.02915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Yi Yang wrote:
> On Mon, 2008-01-07 at 02:57 +0100, Rafael J. Wysocki wrote:
> > On Monday, 7 of January 2008, Yi Yang wrote:
> > > On Fri, 2008-01-04 at 08:09 -0800, David Brownell wrote:
> > > > > > This patch changes empty output to "unsupported" in order that a user knows
> > > > > > wakeup feature isn't supported by this device when he/she
> > > > > > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > > > > > thanks.
> > > > >
> > > > > What about simply removing "wakuep" file if wakeup is not supported?
> > > > 
> > > > It may not *stay* unsupported, so I think changing it in either
> > > > of those permanent ways would be confusing/misleading.
> > > > 
> > > > For example, USB devices have multiple states ... minimally, an
> > > > unconfigured state, and a configured state.  Some have multiple
> > > > configurations.  Only configured states can be wakeup-capable.
> > > > So a given device might have three states, but support wakeup
> > > > except in one of them...
> > > If so, we can change "unsupported" to "unconfigurable" or "inoperable"
> > > which can cover the states "unconfigured", "unsupported" and other
> > > unknown states. :-).
> > 
> > The main problem with your patch is that is changes a documented behavior
> > visible by the user space.  That should be done very cautiously.
> Which applications are using this interface? if they assume "\n" means
> the unconfigurable or unavailable state, this is very fragile.

I can't give you examples right now, but since the behavior has been
documented for quite some time, it's safe to assume there are some unless
proven otherwise.

Also, fragile or not, it is the user space's right to rely on documented
behavior of the kernel.

Thanks,
Rafael
