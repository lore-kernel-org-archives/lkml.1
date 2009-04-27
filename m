Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZD0R0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZD0R0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZD0RZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:25:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbZD0RZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:25:57 -0400
Date: Mon, 27 Apr 2009 10:06:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tim Abbott <tabbott@MIT.EDU>
cc: Sam Ravnborg <sam@ravnborg.org>,
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
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
In-Reply-To: <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu>
Message-ID: <alpine.LFD.2.00.0904270958010.22156@localhost.localdomain>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu> <20090426111924.GD28642@uranus.ravnborg.org> <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Apr 2009, Tim Abbott wrote:
> 
> Does .head.text actually need its own output section here?

Probably not. Does the ARM build system massage the end result some way 
looking for that .text.head section in the end? As you note, nobody else 
cares, and the proper patch may be more along the lines of something 
below.

Of course, most other architectures put the "init" section at the end, and 
leave the HEAD_TEXT in the regular text section, but I suspect the ARM way 
of laying things out (init text first) is probably better, since it allows 
you to free that head code too.

Not that it likely much matters. 

		Linus

---
 arch/arm/kernel/vmlinux.lds.S |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index c90f272..15520be 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -23,13 +23,11 @@ SECTIONS
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #endif
-	.text.head : {
-		_stext = .;
-		_sinittext = .;
-		*(.text.head)
-	}
 
 	.init : {			/* Init code and data		*/
+		_stext = .;
+		_sinittext = .;
+			HEAD_TEXT
 			INIT_TEXT
 		_einittext = .;
 		__proc_info_begin = .;
