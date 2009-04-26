Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZDZQ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZDZQ55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZDZQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:57:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbZDZQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:57:46 -0400
Date: Sun, 26 Apr 2009 09:40:57 -0700 (PDT)
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
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
In-Reply-To: <1240711870-30505-14-git-send-email-tabbott@mit.edu>
Message-ID: <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu>
 <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu>
 <1240711870-30505-14-git-send-email-tabbott@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Apr 2009, Tim Abbott wrote:
>
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.

Btw, this one really needs to unify the two lds files first. Look at 

	diff -u arch/x86/boot/compressed/vmlinux_*.lds

output and realize that they're basially exctly the same except for 
trivial naming differences, and the fact that the64-bit version hs a 
"pgtable" thing.

So this really needs to be done by first unifying the thing so that there 
is _one_ arch/x86/boot/compressed/vmlinux.lds.S file with a preprocessor 
that takes care of the trivial differences, and then after that, the 
".text.init" games should just be removed.

Notice the _removed_. 

I don't think the compressed stuff has any actual "init" code. It is just 
a blob loader that loads the compressed kernel. There should be no need 
for the init sections being special, so the vmlinux.lds.S file should just 
have a ".text*" section.

Hmm?

		Linus
