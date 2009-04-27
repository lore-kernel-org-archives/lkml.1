Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZD0RaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZD0RaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZD0RaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:30:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:63353 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZD0RaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,255,1239001200"; 
   d="scan'208";a="407305220"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@MIT.EDU>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Date: Mon, 27 Apr 2009 10:29:49 -0700
Subject: RE: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
Thread-Topic: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
Thread-Index: AcnHXPHRpgEBDetGSXmdF8323HegcQAABtNg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EDA91F9@orsmsx505.amr.corp.intel.com>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
 <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu>
 <20090426111924.GD28642@uranus.ravnborg.org>
 <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu>
 <alpine.LFD.2.00.0904270958010.22156@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904270958010.22156@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Does .head.text actually need its own output section here?
>
> Probably not. Does the ARM build system massage the end result some way
> looking for that .text.head section in the end? As you note, nobody else
> cares, and the proper patch may be more along the lines of something
> below.

ia64 doesn't seem to care ... I changed the one use of .text.head
to be just .text.  There are a couple of new "section mismatches"
(start_ap -> start_secondary and start_ap -> start_kernel), but
it still boots.

> Of course, most other architectures put the "init" section at the end, and
> leave the HEAD_TEXT in the regular text section, but I suspect the ARM way
> of laying things out (init text first) is probably better, since it allows
> you to free that head code too.

The start_ap code is still needed for hotplug cpu on ia64. So .text.init
won't work for me.

-Tony
