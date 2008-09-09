Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYIIPEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYIIPEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYIIPEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:04:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53357 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYIIPEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:04:11 -0400
Date: Tue, 9 Sep 2008 09:04:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       scottm@somanetworks.com
Subject: Re: [PATCH v2 05/13] PCI: cpci_hotplug: stop managing hotplug_slot->name
Message-ID: <20080909150410.GZ2772@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100027.29542.66879.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909100027.29542.66879.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 04:00:27AM -0600, Alex Chiang wrote:
> We no longer need to manage our version of hotplug_slot->name
> since the PCI and hotplug core manage it on our behalf.
> 
> Now, we simply advise the PCI core of the name that we would
> like, and let the core take care of the rest.

> -static void
> -make_slot_name(struct slot *slot)
> -{
> -	snprintf(slot->hotplug_slot->name,
> -		 SLOT_NAME_SIZE, "%02x:%02x", slot->bus->number, slot->number);
> -}
>  
>  
> +		scnprintf(name, SLOT_NAME_SIZE, "%02x:%02x", bus->number, i);
> +
>  		hotplug_slot->private = slot;

Unfortunately, our name is kind of crappy.  Can we not give the user
anything better than this?  I can't seem to find the CompactPCI
specification to see if we have a better name available.

I wonder if we can use DMI data on this class of machine.  Scott?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
