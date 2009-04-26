Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZDZL0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZDZL0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZDZL0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:26:30 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58794 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZDZL03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:26:29 -0400
Date: Sun, 26 Apr 2009 13:28:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
       David Howells <dhowells@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426112838.GM28642@uranus.ravnborg.org>
References: <1240711870-30505-5-git-send-email-tabbott@mit.edu> <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu> <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-14-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:11:09PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/boot/compressed/Makefile         |    2 +
>  arch/x86/boot/compressed/head_32.S        |    3 +-
>  arch/x86/boot/compressed/head_64.S        |    3 +-
>  arch/x86/boot/compressed/vmlinux_32.lds   |   43 -------------------------
>  arch/x86/boot/compressed/vmlinux_32.lds.S |   45 ++++++++++++++++++++++++++
>  arch/x86/boot/compressed/vmlinux_64.lds   |   48 ---------------------------
>  arch/x86/boot/compressed/vmlinux_64.lds.S |   50 +++++++++++++++++++++++++++++
>  arch/x86/kernel/head_32.S                 |    2 +-
>  arch/x86/kernel/head_64.S                 |    2 +-
>  arch/x86/kernel/vmlinux_32.lds.S          |    4 +-
>  arch/x86/kernel/vmlinux_64.lds.S          |    2 +-
>  11 files changed, 106 insertions(+), 98 deletions(-)
>  delete mode 100644 arch/x86/boot/compressed/vmlinux_32.lds
>  create mode 100644 arch/x86/boot/compressed/vmlinux_32.lds.S
>  delete mode 100644 arch/x86/boot/compressed/vmlinux_64.lds
>  create mode 100644 arch/x86/boot/compressed/vmlinux_64.lds.S


You should split this patch up in smaller pieces.
1) Rename from *lds to *.lds.S (and no other changes)
2) Introduce __HEAD & friends
   And as before do not use HEAD_TEXT_SECTION

But otherwise it looks good. I will take a second look
when new patches are sent.

	Sam
