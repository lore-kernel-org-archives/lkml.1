Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXKMTxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXKMTxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbXKMTwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:52:53 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37783 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbXKMTww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:52:52 -0500
Date: Tue, 13 Nov 2007 12:52:49 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/5] Construct one fakephp slot per pci slot
Message-ID: <20071113195249.GI17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113001336.GC13341@ldl.fc.hp.com> <20071113194815.GC8421@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113194815.GC8421@austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:48:15PM -0600, Linas Vepstas wrote:
> On Mon, Nov 12, 2007 at 05:13:36PM -0700, Alex Chiang wrote:
> > +	slot->name = kmalloc(8, GFP_KERNEL);
> > +	sprintf(slot->name, "fake%d", count++);
> 
> Please use snprintf to avoid buffer overruns!

Or, since kmalloc can return a 32-byte object at smallest, just allocate
32 bytes and continue using sprintf.  fake%d would overflow after
999,999,999,999,999,999,999,999,999 pci devices, by which time we've
run the machine out of memory anyway.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
