Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbXKNPMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbXKNPMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbXKNPM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:12:29 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10982 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbXKNPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:12:28 -0500
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 10:12:27 EST
Date: Wed, 14 Nov 2007 08:01:12 -0700
From: Alex Chiang <achiang@hp.com>
To: Rolf Eike Beer <eike-hotplug@sf-tec.de>
Cc: pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [Pcihpd-discuss] [PATCH 2/5] Construct one fakephp slot per
	pci slot
Message-ID: <20071114150112.GD7523@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Rolf Eike Beer <eike-hotplug@sf-tec.de>,
	pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <200711141339.31839.eike-hotplug@sf-tec.de> <20071114141755.GA7523@ldl.fc.hp.com> <200711141549.50433.eike-hotplug@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711141549.50433.eike-hotplug@sf-tec.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eike,

* Rolf Eike Beer <eike-hotplug@sf-tec.de>:
> Am Mittwoch, 14. November 2007 schrieb Alex Chiang:
> > * Rolf Eike Beer <eike-hotplug@sf-tec.de>:
> > >
> > > This is ugly. Please do it the way we already do e.g. for
> > > acpiphp: add a char[8] to "struct dummy_slot" and just
> > > reference that here.
> >
> > I took at look at the code in acpiphp you're talking about,
> > and I'm not sure why you think the above is "ugly". We're
> > talking about a runtime vs compile time storage for the name,
> > and doing a kmalloc/sprintf is a pretty standard idiom.
> >
> > BTW, I did incorporate both Linas' and Willy's comments, by
> > changing the kmalloc size to an explicit 32, and using
> > snprintf instead.
> >
> > In any case, for your particular comment, I think I'm going
> > to leave it alone for now, and let Greg weigh in with the
> > final recommendation.
> 
> Because we have another allocation of very small size for every
> slot here.
> 
> struct dummy_slot has a size of 4 pointers, that's 16 byte for
> 32 bit architectures. Putting 8 byte of additional storage here
> would save a complete allocation on 32 bit platforms. For 64
> bit platforms the memory usage is the same but we do less
> allocations (i.e. less points to fail) and less memory
> fragmentation.
> 
> Btw: your code lacks a check if kmalloc() returns NULL.

Good points. I'll make your suggested change for v2.

Thanks.

/ac

