Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbXKMUYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbXKMUYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbXKMUYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:24:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59513 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbXKMUYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:24:37 -0500
Date: Tue, 13 Nov 2007 14:24:24 -0600
To: Greg KH <greg@kroah.com>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, matthew@wil.cx, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113202424.GE8421@austin.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113170129.GA20185@kroah.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 09:01:29AM -0800, Greg KH wrote:
> 
> Also, some companies already provide userspace tools to get all of this
> information about the different slots in a system and what is where,
> from userspace, no kernel changes are needed.  So, why add all this
> extra complexity to the kernel if it is not needed?

Second that motion.... I don't get it. What are the goals of this
patch, really?  Just to get a "slot geographical location" from the
kernel?  I'm balancing the intellectual appeal of having a kernel
struct for representing physical objects, against the headache of 
reading (debugging, modifying) code that has yet another struct 
doing yet another thing.  So far, the dread of future headaches 
is winning.

On pseries systems, I deal with something called the "partitionable
endpoint", which I think probably usually corresponds to physical 
slots, but I don't really know.  The hardware guys pitch changeups 
all the time.  Some of these are soldered onto the planar, 
so the are not physical slots. But they are, um, "hotpluggable"
in that you can dynamically add & remove them from the system
(even though you cannot physically unplug the ones that are 
soldered on -- you can only assign them to other hardware partitions
(think hardware VM or hardware Xen)).  So, naively, the physical 
slot concept doesn't really map to what I have to work with; 
it just adds one more appendix to it all, one more thing to 
get confused about.

To be clear: above remarks are for the PowerPC boxes. I have
no clue about how things work on the IBM Intel-based boxes.
And Greg's original "get IBM to agree" remark is about the
Intel-based boxes.

--linas
