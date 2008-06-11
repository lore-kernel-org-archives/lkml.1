Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYFKIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYFKIVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYFKIVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:21:38 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:40877 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYFKIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:21:37 -0400
Date: Wed, 11 Jun 2008 04:21:23 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH -mm 2/2] kexec jump -v11: save/restore device
 state
In-reply-to: <1213146074.21923.10.camel@caritas-dev.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.1.10.0806110418370.4233@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
 <alpine.LFD.1.10.0806101400090.14381@localhost.localdomain>
 <1213146074.21923.10.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jun 2008, Huang, Ying wrote:

> On Tue, 2008-06-10 at 14:01 -0400, Len Brown wrote:
> > 
> > On Tue, 10 Jun 2008, Huang, Ying wrote:
> > 
> > > This patch implements devices state save/restore before after kexec.
> > > 
> > > 
> > > This patch together with features in kexec_jump patch can be used for
> > > following:
> > > 
> > > - A simple hibernation implementation without ACPI support. You can
> > >   kexec a hibernating kernel, save the memory image of original system
> > >   and shutdown the system. When resuming, you restore the memory image
> > >   of original system via ordinary kexec load then jump back.
> > 
> > What part of ACPI's role in hibernation are you trying to avoid
> > 1. enabling wake devices
> > 2. removing power from the system
> > 3. something else?
> 
> ACPI S5 is used instead of S4 for this simple hibernation
> implementation. That is, before creating the hibernation image, the ACPI
> _PTS is not executed, devices are not put into low power state and wake
> devices are not enabled. After creating the hibernation image, the image
> is saved to disk and system is shutdown (go to S5). When resuming from
> hibernated image, ACPI _BFS and _WAK are not executed too.

Doesn't that resume the devices and their drivers into an unknown state?

-Len

