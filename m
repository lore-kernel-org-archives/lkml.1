Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYJXU1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYJXU1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYJXU1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:27:21 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61208 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYJXU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:27:20 -0400
Date: Fri, 24 Oct 2008 16:27:05 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: RE: [PATCH] Subject: Prevent acpi_run_osc from using NULL objects
 (was: Re: Oops in ACPI with git latest)
In-reply-to: <4911F71203A09E4D9981D27F9D8308580AA7FA4F@orsmsx503.amr.corp.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0810241625170.3056@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1224791103.3330.37.camel@localhost.localdomain>
 <1224811642.3330.57.camel@localhost.localdomain>
 <200810240857.18190.rjw@sisk.pl> <200810241349.43166.rjw@sisk.pl>
 <4911F71203A09E4D9981D27F9D8308580AA7FA4F@orsmsx503.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> We've just recently deployed a new module that validates the inputs and outputs
> for the predefined ACPI methods (Those that start with underscore).
> 
> That is the source of these messages:
> 
> > > ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, expected 4 [20080926]
> > > ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return value [20080926]
> 
> For the initial version of this module, we only output messages when the inputs and/or
> outputs don't match the requirements of the ACPI specification. 
> 
> We can change this to returning exceptions in the future.

I expect we're going to have a bunch of false positives with this one,
and indeed may need to even pare the warnings back to only
when CONFIG_ACPI_DEBUG, or acpi=strict or something.

-Len
