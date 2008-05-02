Return-Path: <linux-kernel-owner+w=401wt.eu-S935184AbYEBRRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184AbYEBRRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbYEBRRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:17:06 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:42989 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025AbYEBRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:17:04 -0400
Date: Fri, 2 May 2008 14:15:36 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Paul Mackerras <paulus@samba.org>,
       Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>, venkatesh.pallipadi@intel.com
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080502171536.GA7041@beyonder.ift.unesp.br>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@kernel.org>, Paul Mackerras <paulus@samba.org>,
	Josh Boyer <jwboyer@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Steven Rostedt <rostedt@goodmis.org>, venkatesh.pallipadi@intel.com
References: <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com> <20080502082936.GB2003@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805020750220.5994@woody.linux-foundation.org> <20080502154406.GA6545@beyonder.ift.unesp.br> <alpine.LFD.1.10.0805020859080.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805020859080.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri  2.May'08 at  9:28:08 -0700, Linus Torvalds wrote:

> Quite frankly, it does sound like the hang happens somewhere around the 
> 
> 	hpet_init
> 	hpet_acpi_add
> 	hpet_resources
> 	hpet_resources: 0xfed00000 is busy
> 
> printk's you added (correct?) and we've had tons of issues with NO_HZ, so 
> at a guess it is timer-related.

It happens a bit before that because when it hangs it doesn't 
print the above lines, and when it does not hang these lines are
the ones right after the point where it hangs. 

> (And I assume it's stable if/once it gets past that boot hang issue? 

Yes you are right. When I have luck and the boot succeeds my Sony laptop
is rock solid and the kernel is wonderful (even the card reader works!).

> That
> tends to mean that it's not some hardware instability, it's literally our 
> init code).

A few days ago I found this message in lkml in reply to a hpet patch
http://lkml.org/lkml/2007/5/7/361 in which the reporter also had 
a similar hang, which was cured by hpet=disable. 

So it is in my TODO list to try to check out if that patch is 
in the current -git and whether it can be reverted somehow (I 
added Venki to the Cc: now)

Thanks a lot for the answer!
