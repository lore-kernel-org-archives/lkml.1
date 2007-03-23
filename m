Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXCWVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXCWVu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbXCWVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:50:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:46288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933862AbXCWVu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:50:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,321,1170662400"; 
   d="scan'208"; a="215168380:sNHT2974565328"
Message-ID: <46044BB5.7080209@intel.com>
Date: Fri, 23 Mar 2007 14:50:45 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Mitch Williams <mitch.a.williams@intel.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH 2.6.20.3] Flush writes to MSI-X table
References: <1174597699.24177.32.camel@strongmad> <20070323210729.GC12182@suse.de>
In-Reply-To: <20070323210729.GC12182@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Mar 22, 2007 at 02:08:19PM -0700, Mitch Williams wrote:
>> Because both MSI-X interrupt messages and MSI-X table writes are posted,
>> it's possible for them to cross while in-flight.  This results in
>> interrupts being received long after the kernel thinks they're disabled,
>> and in interrupts being sent to stale vectors after rebalancing.
>>
>> This patch performs a read flush after writes to the MSI-X table for
>> enable/disable and rebalancing operations.  Because this is an expensive
>> operation, we do not perform the read flush after mask/unmask
>> operations.  Hardware which supports MSI-X typically also supports some
>> sort of interrupt moderation, so a read-flush is not necessary for
>> mask/unmask operations.
>>
>> This patch has been validated with (unreleased) network hardware which
>> uses MSI-X.
> 
> Is this needed for any hardware that is public today?

yes. Every msi-x capable piece of hardware in the field will crash if it does 
any form of interrupt balancing. (okay that is not that much stuff out there... 
I know, but the patch is not that big at all - all it does is subtly add a few 
read flushes to make sure that critical changes in the msix vector tables are 
pushed out at the proper time).

> Also, it seems a bit too big of a patch for -stable right now,
> especially as the mainline patch will not make it into 2.6.22 at the
> earliest.

I think Mitch was way too sensitive when he worded his e-mail. We should really 
be trying to get this fix into 2.6.21 at least.

Mitch, can you re-post this and include Eric Biederman, linux-pci, our intel 
platform guys and perhaps Linus and Andrew?

A lot of vendors (not just us) will be pushing msi-x capable hardware out, and 
this fix is absolutely needed. Getting it in soon is really preferred. Not to 
mention that Mitch has spent well over 8 weeks I think making sure that this is 
indeed the issue and the proper fix...

Auke
