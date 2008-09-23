Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYIWBRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYIWBRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYIWBQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:16:54 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12222 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYIWBQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:16:52 -0400
Date: Mon, 22 Sep 2008 19:16:48 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 04/13] PCI: acpiphp: remove 'name' parameter
Message-ID: <20080923011648.GC1814@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, kaneshige.kenji@jp.fujitsu.com
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100022.29542.90739.stgit@bob.kio> <20080909143831.GY2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909143831.GY2772@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Tue, Sep 09, 2008 at 04:00:22AM -0600, Alex Chiang wrote:
> > We do not need to manage our own name parameter, especially since
> > the PCI core can change it on our behalf, in the case of duplicate
> > slot names.
> 
> Looks good, just a question ...
> 
> >  	acpiphp_slot->slot = slot;
> > -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
> > +	scnprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
> >  
> 
> What's the difference between snprintf and scnprintf?

I think this may have already been answered somewhere else, but
scnprintf tells you number of characters that actually fits into
the buffer whereas snprintf tells you the number of characters
that _would_ have fit into the buffer it were big enough.

> And why were we bothering to use snprintf anyway?  For when we fall into a
> parallel universe where a u32 can have more than twenty digits?

Well, I think there are some in-flight patches that want to
change sun to a 64 bit value, which makes me think we want to
change SLOT_NAME_SIZE to 21...

/ac

