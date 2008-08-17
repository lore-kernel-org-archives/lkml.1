Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYHQTUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYHQTUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYHQTUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:20:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYHQTUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:20:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Date: Sun, 17 Aug 2008 21:23:18 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200808141753.58547.rjw@sisk.pl> <20080817022323.GN19125@one.firstfloor.org> <200808171925.48584.rjw@sisk.pl>
In-Reply-To: <200808171925.48584.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808172123.19172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Rafael J. Wysocki wrote:
> On Sunday, 17 of August 2008, Andi Kleen wrote:
> > > > > I'm still seeing it on 2.6.27-rc2, even with the 
> > > > > patch here http://lkml.org/lkml/2008/7/30/171 and the
> > > > > wbinvd_halt code patch applied.  Maybe something else
> > > > > broke in some of the recent hotplug changes?
> > > > 
> > > > My guess is that MCE does somthing that is not allowed by sysfs any more.
> > > 
> > > Hm, sysfs hasn't changed any in 2.6.27-rcX that I know of.
> > 
> > mce hasn't either in this regard. My current theory is that the CPU 
> > up/down notifiers are not balanced anymore (as in duplicated up events) 
> 
> It doesn't look like this is the case.  Moreover, had that been the case, we'd
> have had many reports from people doing suspend/hibernation, but it doesn't
> happen.
> 
> I think that cpu_down() fails for some reason and that causes the subsequent
> onlining to fail.

Well, no.  If my understanding of the CPU hotplug code is correct, this is not
possible.

The next possibility is that for some 'i' mce_attributes[i] is NULL, although
there are non-NULL values for some j > i.  In that case, mce_remove_device()
would fail to remove device_mce for given CPU and the subsequent
mce_create_device() would cause the observed failure.

Thanks,
Rafael
