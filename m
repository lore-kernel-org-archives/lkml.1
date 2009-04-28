Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZD1I5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZD1I5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZD1I5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:57:40 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:57355 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZD1I5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:57:39 -0400
Date: Tue, 28 Apr 2009 10:56:53 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
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
       Kyle McMartin <kyle@mcmartin.ca>, David Howells <dhowells@redhat.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090428085653.GA28601@linux-mips.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu> <1240711870-30505-5-git-send-email-tabbott@mit.edu> <20090426111924.GD28642@uranus.ravnborg.org> <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904270958010.22156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904270958010.22156@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:06:26AM -0700, Linus Torvalds wrote:

> On Mon, 27 Apr 2009, Tim Abbott wrote:
> > 
> > Does .head.text actually need its own output section here?
> 
> Probably not. Does the ARM build system massage the end result some way 
> looking for that .text.head section in the end? As you note, nobody else 
> cares, and the proper patch may be more along the lines of something 
> below.
> 
> Of course, most other architectures put the "init" section at the end, and 
> leave the HEAD_TEXT in the regular text section, but I suspect the ARM way 
> of laying things out (init text first) is probably better, since it allows 
> you to free that head code too.

There are a few platforms were due to excess bootloader primitivity (read
the boot format is a simple blob) it is desireable to have the entry point
at the lowest address of the final image - because that is what the firmware
is expecting.

  Ralf
