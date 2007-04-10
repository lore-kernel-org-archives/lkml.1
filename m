Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXDJIPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXDJIPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbXDJIPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:15:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:60036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbXDJIP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:15:29 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: CPU offline but power consumption increased?
Date: Tue, 10 Apr 2007 04:13:51 -0400
User-Agent: KMail/1.9.5
Cc: "Andika Triwidada" <andika@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <7e0bae390704062123i2dfaf030icd5a710677bc989a@mail.gmail.com> <p73odlzkb6h.fsf@bingen.suse.de>
In-Reply-To: <p73odlzkb6h.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704100413.51637.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2007 19:38, Andi Kleen wrote:
> "Andika Triwidada" <andika@gmail.com> writes:
> 
> [cc linux-acpi]
>  
> > Question: is that normal? I thought power consumption will be
> > automatically reduced if one core offlined.

Known?  Yes.
What people would expect? No.

http://bugzilla.kernel.org/show_bug.cgi?id=5471

> The current cpu offline essentially just runs a special idle loop.
> The standard idle loop is even a bit more aggressive on some systems
> because it knows about the deeper ACPI sleep modi.
> 
> There are also dependencies between cores because current CPUs
> have shared power planes between cores.
> 
> I suppose in the future when a whole socket goes off line one could
> implement special code to turn off the CPU further. But it likely
> won't work on older hardware.

Speaking for all Intel hardware implemented from pre-history until now,
deep C-states is the best you can do, and there is no special offline
mode to save more power.

If you really want to not use a core and the above bug isn't fixed in linux,
you can use maxcpus=1 to never bring the other core on-line in the first place,
and if the BIOS is implemented properly, the core will be spinning in the
deepest available C-state.  Of course, it would probably be more interesting
to simply leave the core on-line and let it go idle...

-Len
