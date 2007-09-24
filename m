Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbXIXVc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbXIXVc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbXIXVcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:32:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbXIXVcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:32:42 -0400
Date: Mon, 24 Sep 2007 17:32:24 -0400
From: Dave Jones <davej@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
Message-ID: <20070924213224.GI8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Oeser <ioe-lkml@rameria.de>, Andi Kleen <andi@firstfloor.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <20070915003906.5fa6dc0f.akpm@linux-foundation.org> <200709151258.28745.ioe-lkml@rameria.de> <20070915040802.bb3c7093.akpm@linux-foundation.org> <20070915120824.GA21243@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915120824.GA21243@srcf.ucam.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 01:08:25PM +0100, Matthew Garrett wrote:
 > On Sat, Sep 15, 2007 at 04:08:02AM -0700, Andrew Morton wrote:
 > 
 > > I believe that about two years ago we broke something which caused quite a
 > > large number of people to need noapic.  Is that the case with any of your
 > > machines?  Do you know if they run 2.6.ancient without noapic?
 > 
 > My recollection is that we shifted from "Enable the apic even if the 
 > BIOS disabled it" to "Only use the apic if the BIOS didn't disable it" 
 > around that time, which meant that distributions could actually turn on 
 > apic-on-up support without breaking everything. That might correspond to 
 > what you're seeing.

If memory serves correctly, that was circa 2.6.10, back in these commits..

commit a068ea13d1db406e15c346e93530343f6e70184c
Author: Len Brown <len.brown@intel.com>
Date:   Sun Oct 10 05:21:08 2004 -0400

    [ACPI] If BIOS disabled the LAPIC, believe it by default.
    "lapic" is available to force enabling the LAPIC
    in the event you know more than your BIOS vendor.
    http://bugzilla.kernel.org/show_bug.cgi?id=3238

commit 2fcfece90db9643b6f30a7ad343898a2871e6a81
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 9 20:12:45 2004 -0400

    [ACPI] Don't enable LAPIC when the BIOS disabled it.
    Doing so apparently breaks every Dell on Earth.
    http://bugzilla.kernel.org/show_bug.cgi?id=3238


But those changes relate to the local APIC, which 'noapic' shouldn't
have any effect on should it ?

	Dave

-- 
http://www.codemonkey.org.uk
