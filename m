Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbXKMUg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbXKMUg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbXKMUgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:36:49 -0500
Received: from palrel13.hp.com ([156.153.255.238]:45279 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912AbXKMUgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:36:48 -0500
Date: Tue, 13 Nov 2007 13:36:45 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113203645.GB22812@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113185122.GA22536@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com>:
> 
> Ok, again, I want to see the IBM people sign off on this, after
> testing on all of their machines, before I'll consider this, as
> I know the IBM acpi tables are "odd".

Who would be a good contact at IBM to get some eyes / machine
time on this?

> Also, how about Dell machines?  I know they are probably not
> expecting this information to show up and who knows if the
> numbering of their slots match up with their physical diagrams 

Who would be a good contact at Dell for the same?

I don't have as much experience with oddball firmware from
various vendors as others on this list, but given the rather
stable definition of _SUN in the ACPI spec, I'd be surprised to
see vendors abusing that method. [I fully accept the possibility
that I'm just naive ;)]

More likely, a vendor will do what the HP Proliant folks did,
that being simply omitting a _SUN method altogether.

One more thought on that -- at *worst* my patch series will do no
worse than the status quo of what the acpiphp module is doing
today. That module walks through the namespace looking for _SUN
methods, and when it finds them, it creates an entry in exactly
the same spot (/sys/bus/pci/slots/N) that my patch series does.

What this series adds beyond acpiphp is adding entries for slots
that aren't hotpluggable.

> IBM sells a program that does this for server rooms.  It's
> probably part of some Tivoli package somewhere, sorry I don't
> remember the name.  I did see it working many years ago and it
> required no kernel changes at all to work properly.

Like I said in an earlier email, HP ia64 systems will require a
kernel change to get this information. Whether it comes via a
generic ACPI access layer like dev_acpi, or something like this
patch series, the kernel will still get touched.

Thanks.

/ac

