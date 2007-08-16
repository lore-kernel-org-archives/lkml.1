Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbXHPRDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbXHPRDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 13:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXHPRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 13:03:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:49569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbXHPRDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 13:03:42 -0400
Subject: RE: scripts/mod/file2alias.c cross compile problem
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Dittmer <jdi@l4x.org>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
In-Reply-To: <617E1C2C70743745A92448908E030B2A022DBC43@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com>
	 <1186092501.6131.154.camel@localhost.localdomain>
	 <1187274435.8780.780.camel@queen.suse.de>
	 <617E1C2C70743745A92448908E030B2A022DBC43@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 16 Aug 2007 19:03:37 +0200
Message-Id: <1187283817.8780.837.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 09:26 -0700, Luck, Tony wrote:
> > -#define ACPI_ID_LEN	9
> > +#define ACPI_ID_LEN	16 /* only 9 bytes needed here, 16 bytes are used */
> 
> What will happen if someone uses more than 9 bytes?  With the old
> limit there would be a compile time error it someone initialized
> with:
> 
> 	{"PNP0C0ABCDEFGH", 0},
> 
> But if we change ACPI_ID_LEN the error will move to run-time.

That should not harm.
>From spec point of view only 8 bytes are needed. Here 9 bytes are used
as then string functions can be used. The whole rest of the kernel does
not use ACPI_ID_LEN.
If someone defines such an id, his driver won't ever get loaded and he
gets bug reports very soon anyway.

Hmm, I wonder whether this even may come in handy later:
Some BIOSes have some spec violating strange hids like:
"*PNP0C0A"
or
"_PNP0C0A"
While I thought the "_" or "*" should be cut away by ACPI parser, it
might be a hint to the OS to do something special. AFAIK only very
specific devices (WMI and some graphics?) have such strange hids
defined, those drivers could explicitly match for the spec violating
string then.

   Thomas

