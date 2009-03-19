Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZCSRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZCSRA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZCSRAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:00:48 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27550 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZCSRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:00:47 -0400
Date: Thu, 19 Mar 2009 11:00:45 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 10/12] PCI Hotplug: restore fakephp interface with
	complete reimplementation
Message-ID: <20090319170045.GD8074@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224016.887.47034.stgit@bob.kio> <20090319024555.1fed0dac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319024555.1fed0dac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 18 Mar 2009 16:40:16 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > A complete re-implementation of fakephp is necessary if it is to
> > present its former interface (pre-2.6.27, when it broke).
> 
> We broke an existing interface?  wtf?

When I introduced physical PCI slots in 2.6.27, one of the
changes was that the interface we presented in
/sys/bus/pci/slots/ was supposed to represent _physical_ slots
only.

Before the change, fakephp "abused" that directory by presenting
all the PCI devices, independent of any notions of physical
slots.

No one thought much of changing what fakephp did during review
because we thought it was a developer/debug feature only. After
the change, instead of presenting a PCI bus address in sysfs,
fakephp present something like "fake%d" where %d is the order
that we discovered the device.

The thought process was that, "this is a debug feature only, so
let's make it more obvious".

This was an incorrect assumption, it turns out. :(

People like embedded were using it for various things, and it was
also the only way to remove (and rediscover) PCI devices (if they
weren't supported by platform hotplug).

You can read the thread here:

	http://thread.gmane.org/gmane.linux.kernel/761944

The interesting stuff starts in the middle.

> If it's been broken for this long then do we actually need to
> resurrect it?

This entire patch series is about fixing the mess that I helped
create. At the time, it was indicated that there was existing
software that depended on finding 2.6.26-style (and older)
fakephp stuff in /sys/bus/pci/slots/

After some discussion, we thought it would be better for the
functionality to live in the new sysfs interfaces I'm introducing
in this series.

The legacy fakephp stuff is to help transition existing software.

Since the only use case of existing software that I know of is in
embedded, I think their workaround was to not move to 2.6.27.

> If so, do we need to resurrect it in its old form?  This would appear
> to be an opportunity to improve that interface, unless the old one
> was perfect?

Well, the goal is to get people away from fakephp completely and
move them to these new interfaces. The legacy fakephp stuff is
just a transition aid.

Thanks.

/ac

