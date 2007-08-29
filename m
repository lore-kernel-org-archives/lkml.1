Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXH2TaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXH2TaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXH2T3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:29:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbXH2T3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:29:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
Date: Wed, 29 Aug 2007 21:40:24 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "pm list" <linux-pm@lists.linux-foundation.org>
References: <200708272347.45438.rjw@sisk.pl> <200708290005.12323.rjw@sisk.pl> <B28E9812BAF6E2498B7EC5C427F293A4031EFC32@orsmsx415.amr.corp.intel.com>
In-Reply-To: <B28E9812BAF6E2498B7EC5C427F293A4031EFC32@orsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708292140.25212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 August 2007 18:54, Moore, Robert wrote:
> No, it's not safe to run the AML interpreter with interrupts disabled.

OK

> I don't have any problem with introducing finer granularity enter/exit
> sleep interfaces if they are required.
> 
> I would suggest that we rename things a bit however.
> 
> Currently:
> acpi_enter_sleep_state_prep
> acpi_enter_sleep_state_prep_late
> acpi_enter_sleep_state
> 
> acpi_leave_sleep_state_prep
> acpi_leave_sleep_state
> 
> I think we can truncate and clarify:
> 
> acpi_sleep_setup1
> acpi_sleep_setup2
> acpi_sleep
> 
> acpi_wake_setup1
> acpi_wake

That's perfectly fine by me.  I'll update the 2/3 patch to use these names.

Also, I think we can remove acpi_enter_sleep_state_s4bios() entirely (in a
separate patch).

> acpi_set_sleep_state_indicator:
> 
> I'm not sure if we have any external interfaces that simply execute a
> control method, seems like overkill.
> 
> Please give me more information as to why _SSI needs to be moved (other
> than executing it after _BFS)

The _SST after _BFS is okay, but the invocation of _SST in acpi_wake()
(currently acpi_leave_sleep_state) is problematic, since it causes the
indicator to be set to "working" during hibernation, before the image is
saved.  Thus, during hibernation _SST shouldn't be called from acpi_wake().

For this reason, I thought it would be a good idea to call _SST from a separate
routine that might be invoked by higher level functions as desired.

Greetings,
Rafael
