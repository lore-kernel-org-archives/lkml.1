Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZD0RD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZD0RD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZD0RDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:03:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41473 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZD0RDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:03:12 -0400
Date: Mon, 27 Apr 2009 18:00:17 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090427170017.GB30189@flint.arm.linux.org.uk>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu> <20090426111924.GD28642@uranus.ravnborg.org> <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 12:46:21PM -0400, Tim Abbott wrote:
> On Sun, 26 Apr 2009, Sam Ravnborg wrote:
> 
> > > -	.text.head : {
> > > +	HEAD_TEXT_SECTION : {
> > 
> > Spell it out direct rather than hiding the .head.text
> > behind a macro name here.
> 
> Does .head.text actually need its own output section here?  I notice that 
> only the linker scripts for arm, x86, and ia64 have an output section for 
> .head.text; the rest just place it at the start of the .text or .init.text 
> output section.  It would be great if we could eliminate these extra 
> references to .head.text by doing the same thing here.

It could be merged with the .init section.  IOW, it becomes:

        .init : {                       /* Init code and data           */
                _stext = .;
                _sinittext = .;
                *(.text.head)
                        INIT_TEXT
                _einittext = .;
                __proc_info_begin = .;
                        *(.proc.info.init)
                __proc_info_end = .;
...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
