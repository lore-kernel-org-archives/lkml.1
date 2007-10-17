Return-Path: <linux-kernel-owner+w=401wt.eu-S1763879AbXJQOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763879AbXJQOCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXJQOC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:02:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55924 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXJQOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:02:26 -0400
Date: Wed, 17 Oct 2007 08:02:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Lord <lkml@rtr.ca>
Cc: Theodore Tso <tytso@mit.edu>, pcihpd-discuss@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [Pcihpd-discuss] [PATCH 1/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version 2)
Message-ID: <20071017140224.GD16728@parisc-linux.org>
References: <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca> <20071017032907.GA16728@parisc-linux.org> <47160984.7030308@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47160984.7030308@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 09:09:24AM -0400, Mark Lord wrote:
> > I'd argue these comments fall under "stating the bleedin' obvious", but
> > that's Kristen's call.
> 
> Hey, they're original to the file.  I'm just keeping checkpatch.pl happy here.
> Ditto for everything else you commented on.

I can see that they were there before. I just think the appropriate
patch is to delete them rather than to move them

> >>  	case INT_PRESENCE_OFF:
> >>  		if (!HP_SUPR_RM(ctrl->ctrlcap))
> >>  			break;
> >> -		dbg("Surprise Removal\n");
> >> +		dbg("Surprise Event\n");
> >>  		update_slot_info(p_slot);
> >>  		handle_surprise_event(p_slot);
> >>  		break;
> > 
> > That doesn't seem like an obviously correct change to me.  Can you
> > explain?
> 
> Yeah.  You clipped the top line:  case INT_PRESENCE_ON:
> So that code can be run for both hot plug and hot remove operations.

I didn't clip it -- diff did when it inserted three lines of context.

> ..
> >> -	temp_word = (temp_word & ~intr_enable) | intr_enable; 
> >> +	temp_word = (temp_word & ~intr_enable) | intr_enable;
> > 
> > *boggle*
> 
> Dig out your text editor, and notice the excess whitespace at the end of the line,
> along with similar stuff on most other lines in this patch.

You, however, did clip the important line.

> > 	temp_word |= intr_enable;

which is what I was saying the above is equivalent to.

> This is all just stuff that checkpatch.pl complains about when
> the later patches are applied, so patch 01_... serves to reduce
> the noise level from checkpatch.pl for the *real* patches which follow.

I know, but if you're going to remove whitespace from a line, you might
as well change the line to look like idiomatic C rather than something
an Ada programmer wrote.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
