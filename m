Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYIWBU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYIWBU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYIWBUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:20:17 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38798 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYIWBUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:20:16 -0400
Date: Mon, 22 Sep 2008 19:20:15 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com
Subject: Re: [PATCH v2 06/13] PCI: cpqphp: stop managing hotplug_slot->name
Message-ID: <20080923012015.GD1814@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100032.29542.18371.stgit@bob.kio> <20080909150835.GA2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909150835.GA2772@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Tue, Sep 09, 2008 at 04:00:32AM -0600, Alex Chiang wrote:
> > -static inline void make_slot_name(char *buffer, int buffer_size, struct slot *slot)
> > -{
> > -	snprintf(buffer, buffer_size, "%d", slot->number);
> > -}
> 
> > +
> > +		scnprintf(name, SLOT_NAME_SIZE, "%d", slot->number);
> 
> So ... we're using %d here and %u in acpiphp.  Obviously we don't expect
> to get a number above 2 billion, but I think if we do have some utterly
> bogus firmware that gives us a number above 2 billion, printing a
> positive number is a better user experience than a negative number.

Well, on some HP machines, a slot number >2 billion actually does
make sense, if you convert it to hex, and then consider that to
be some sort of encoding for topology.

But your point here stands, I can change this driver to a %u.

> We clearly have a common pattern here where hotplug drivers have a
> number insteaqd of a name (I would venture this is the most common).
> Maybe we need a common helper?  I think this is a subject for the
> long-term todo list, not something that needs to be addressed in the
> context of this patch series.

Yeah, ok -- long term todo. ;)

/ac

