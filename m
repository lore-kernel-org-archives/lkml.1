Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYJIUhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYJIUhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYJIUgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:36:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:16580 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYJIUgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:36:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,385,1220252400"; 
   d="scan'208";a="57542222"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Date: Thu, 9 Oct 2008 13:35:17 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005B12E14@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20081009175000.GC6912@sequoia.sous-sol.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Thread-Index: AckqN4ce6BvXeg4+TzScp+6ZsUNVtgAFVNUQ
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com> <20081009130518.GE1623@ucw.cz> <20081009175000.GC6912@sequoia.sous-sol.org>
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: "Chris Wright" <chrisw@sous-sol.org>, "Pavel Machek" <pavel@suse.cz>
Cc: <linux-kernel@vger.kernel.org>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 09 Oct 2008 20:35:22.0478 (UTC) FILETIME=[8D64D0E0:01C92A4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Chris Wright [mailto:chrisw@sous-sol.org]
> Sent: Thursday, October 09, 2008 10:50 AM
> 
> * Pavel Machek (pavel@suse.cz) wrote:
> > > +struct tboot_acpi_sleep_info {
> > > +	u16 pm1a_cnt;
> > > +	u16 pm1b_cnt;
> > > +	u16 pm1a_evt;
> > > +	u16 pm1b_evt;
> > > +	u16 pm1a_cnt_val;
> > > +	u16 pm1b_cnt_val;
> > > +}  __attribute__ ((__packed__));
> > > +
> > > +struct tboot_shared {
> > > +	/* version 0x01+ fields: */
> > > +	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
> > > +	u32  version;      	/* Version number: 2 is current */
> > > +	u32  log_addr;     	/* physical addr of tb_log_t log */
> > > +	u32  shutdown_entry32;	/* entry point for tboot shutdown from
> > > 32b */
> > > +	u32  shutdown_entry64;	/* entry point for tboot shutdown from
> > > 64b */
> >
> > should these be function pointers?

Function ptrs don't work for an ABI since they are different sizes for
32b and 64b binaries.

> I asked earlier, I didn't understand why it needs to be 2 fields,
since
> it's u32 in both cases and can't both be used at once.

We will look at seeing if we can make a single entry point that detects
if it was called by 64b code, disable IA32e mode, and then jumps to the
32b code.  We did it this way initially because it was easier code to
keep them separate and has been working for some time.  We'll also have
to adjust Xen if/when we do this.

Joe
