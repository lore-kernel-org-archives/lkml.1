Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZFZU7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZFZU7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZFZU7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:59:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:40509 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbZFZU7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:59:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,298,1243839600"; 
   d="scan'208";a="158979479"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 26 Jun 2009 13:59:02 -0700
Subject: RE: [PATCH 8/9] x86/apic: match destination id with destination mode
Thread-Topic: [PATCH 8/9] x86/apic: match destination id with destination
 mode
Thread-Index: Acn2l/afl49OjUQqSfmTDpWfPVPjeQAB1M7Q
Message-ID: <43F901BD926A4E43B106BF17856F0755641A46AA@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com>
	<20090626071725.GE14078@elte.hu> <m1hby293fh.fsf@fess.ebiederm.org>
In-Reply-To: <m1hby293fh.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Ingo Molnar <mingo@elte.hu> writes:
>
>> The question here is whether this should layer on top of Jeremy's
>> IO-APIC driverization patches. I think it should.
>
>The patch is a bad hack that is totally misdocumented.  A bit
>like the Xen apic changes in that respect.
>
>I haven't seen Jeremy's IO-APIC driverization patches.
>
>I am stumped why we need any driverization in this area.  x86_64 and has
>had for years a mechanism that is perfectly fine for abstracting this.
>i386 also has had something similar and last I looked we just about
>had that code merged.
>
>Xen doesn't have ioapics so it doesn't need us faking writes to
>ioapics.  Xen either needs to parse the ioapic tables itself
>or Xen needs a proper interface to be given the table information.
>
>I this patch can be replaced by a 2 line change to the apic mode
>logic to force us into physflat mode on moorestown.
>
>Eric
>

[[JPAN]] For Moorestown production silicon, we will use apic_default which uses
 logical dest mode. This patch is not required.
But, I think it is wrong to assign destination ID without looking at the mode 
bit. If we have a new apic_xxxx with phy dest mode, we would have logical APIC 
ID assigned to physical mode.
