Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYIIVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYIIVRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 17:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYIIVRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 17:17:30 -0400
Received: from mailhost.somanetworks.com ([216.126.67.42]:56354 "EHLO
	mail.somanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYIIVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 17:17:29 -0400
Date: Tue, 9 Sep 2008 17:11:33 -0400 (EDT)
From: Scott Murray <scottm@somanetworks.com>
X-X-Sender: scottm@rancor
To: Matthew Wilcox <matthew@wil.cx>
cc: Alex Chiang <achiang@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH v2 05/13] PCI: cpci_hotplug: stop managing
 hotplug_slot->name
In-Reply-To: <20080909150410.GZ2772@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0809091702270.6809@rancor>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100027.29542.66879.stgit@bob.kio> <20080909150410.GZ2772@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008, Matthew Wilcox wrote:

> On Tue, Sep 09, 2008 at 04:00:27AM -0600, Alex Chiang wrote:
> > We no longer need to manage our version of hotplug_slot->name
> > since the PCI and hotplug core manage it on our behalf.
> >
> > Now, we simply advise the PCI core of the name that we would
> > like, and let the core take care of the rest.
>
> > -static void
> > -make_slot_name(struct slot *slot)
> > -{
> > -	snprintf(slot->hotplug_slot->name,
> > -		 SLOT_NAME_SIZE, "%02x:%02x", slot->bus->number, slot->number);
> > -}
> >
> >
> > +		scnprintf(name, SLOT_NAME_SIZE, "%02x:%02x", bus->number, i);
> > +
> >  		hotplug_slot->private = slot;
>
> Unfortunately, our name is kind of crappy.  Can we not give the user
> anything better than this?  I can't seem to find the CompactPCI
> specification to see if we have a better name available.
>
> I wonder if we can use DMI data on this class of machine.  Scott?

This is about all that can be done, unfortunately.  I've never seen
anything useful with regards to this in DMI on the boards I've looked
at, and we would have to rework the board driver -> CPCI hotplug core
interface to pass that information along even if we could get it for
some boards.  In general, it is a difficult problem to solve since the
same set of system master and peripheral boards in a different chassis
could very well be at different geographic addresses depending on where
the chassis vendor has placed the system master slot(s).

Scott


-- 
Scott Murray
SOMA Networks, Inc.
Toronto, Ontario
e-mail: scottm@somanetworks.com
