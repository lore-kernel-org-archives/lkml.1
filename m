Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZF3QIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZF3QIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 12:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZF3QIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 12:08:36 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:33183 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273AbZF3QIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 12:08:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=p+8oaTaoBged2jK6melhLhzrDQy7/zds0QXfc4BkT3GMbG5oYvwbcpCBFEelLvujJzTtfDRWHNtrNB0DEQob8xorRh28ctG9XBsV05z4J/Z34way9BiVaZbac9+1yNF9;
Date: Tue, 30 Jun 2009 09:08:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Alberto Gonzalez <alberto6674@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090630090835.5536a465@jbarnes-g45>
In-Reply-To: <alpine.DEB.2.00.0906300445550.4758@skynet.skynet.ie>
References: <200906280821.58631.info@gnebu.es>
	<200906281622.10072.info@gnebu.es>
	<ac3eb2510906280728s1d80c417w64ce6985e9ed8f64@mail.gmail.com>
	<200906300540.18916.info@gnebu.es>
	<alpine.DEB.2.00.0906300445550.4758@skynet.skynet.ie>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 04:46:38 +0100 (IST)
Dave Airlie <airlied@linux.ie> wrote:

> 
> > On Sunday 28 June 2009 16:28:44 Kay Sievers wrote:
> > > If there isn't something else running which acts on uevents that
> > > trigger drm events, which I wouldn't expect, it seems like a drm
> > > kernel problem.
> > 
> > Ok, thanks for looking at it. I'll sum up the problem for DRM
> > people:
> > 
> > The problem started after upgrading to 2.6.30. At some point, udevd
> > starts to use a lot of CPU time. It happens randomly, but it seems
> > easier to trigger when running something graphics intensive
> > (glxgears, gtkperf, tuxracer..).
> > 
> > Killing udevd and starting it with the --debug switch throws up
> > this when the problem starts:
> 
> I've added jbarnes to the list,
> 
> Jesses are we sending events yet? what for?

Right now we just send uevents at hotplug time, so maybe one of our
hotplug interrupt bits is getting stuck, resulting in a continuous
stream of events as we generate other interrupts (which would happen
when running 3D apps for example).

There's a DRM_DEBUG statement in drivers/gpu/drm/i915/i915_irq.c under
the if (I915_HAS_HOTPLUG(dev)) { check, if you make it into DRM_ERROR
we can see which one is getting stuck.

-- 
Jesse Barnes, Intel Open Source Technology Center
