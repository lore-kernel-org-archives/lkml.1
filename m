Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbXFBXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbXFBXNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761989AbXFBXNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:13:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:50657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760064AbXFBXNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:13:47 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
Date: Sat, 2 Jun 2007 19:13:26 -0400
User-Agent: KMail/1.9.5
Cc: Tear <tarrqt@yahoo.com>, mingo@redhat.com, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <105227.2990.qm@web63604.mail.re1.yahoo.com> <alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706021913.27351.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 June 2007 17:28, Linus Torvalds wrote:

> Finally, I wonder why that particular box is marked with an "acpi=ht" 
> blacklisting in the first place. Rather than add a new blacklist, it migth 
> be better to remove an old (and perhaps incorrect) one.
> 
> That blacklist entry is _ancient_. It's entirely possible that it's just 
> bogus: we've had so many ACPI fixes since it was added, that it's quite 
> possible that the blacklist entry itself is bogus, and is the result of 
> some old ACPI bug that triggered on that entry.
> 
> The Dell GX240 entry was added by commit 68e4ad79294 in the historic Linux 
> archive:
> 
>     Author: Len Brown <len.brown@intel.com>
>     Date:   Sat Aug 9 15:00:59 2003 -0400
> 
>     ACPI from 2.4:
>     build: add ACPI_HT, delete ACPI_HT_ONLY
>     boot: add acpi={force, off, ht}; delete "noht", "acpismp="
>     add DMI blacklist from UnitedLinux
>
> and since it sounds like the machine _works_ with ACPI on, my real 
> preference would be to just remove the black-list entry.
> 
> In fact, I thought that patch already existed in the -mm tree?

Yes, Tear sent the correct patch a while back, akpm picked it up, and i slurped
it into my tree just last night for 2.6.23:

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=4d2fafd17a325b3f4f5f9edb1211bc7f4c311269

> Len - do you have any archives back from 2003 and earlier to indicate why 
> the Dell GX240 was blacklisted?

Yep, it came to us in this Cset on 2003-08-09
http://linux.bkbits.net:8080/linux-2.6.11-stable/?PAGE=cset&REV=3f35b56btNYYpQfjOuQmiUdjSGFtWg

A young, impressionable maintainer, I'd been working on Linux for about 2 months.
I sync'd the workarounds from 2.4 into 2.5, and this particular one came
from the "UnitedLinux" tree.

My theory at the time was that SuSE had been most successful deploying ACPI,
and so upstream should benefit from their workarounds.
I later realized that this was a strategic mistake, as distro workarounds
often paper-over real bugs by addressing the symptom only.
A bunch of these entries were removed over time, and these days I add
DMI workarounds only when we are sure we have the root cause.

cheers,
-Len
