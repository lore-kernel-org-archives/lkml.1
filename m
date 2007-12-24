Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbXLXBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbXLXBP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 20:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXLXBPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 20:15:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbXLXBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 20:15:22 -0500
Date: Sun, 23 Dec 2007 17:14:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: "H. Peter Anvin" <hpa@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-Reply-To: <alpine.LFD.0.9999.0712231621340.21557@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712231703390.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712232320.21182.rjw@sisk.pl> <476EEB6F.7080909@kernel.org> <200712240009.41764.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712231621340.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Linus Torvalds wrote:
> 
> IOW, it looks like the normal kind of ACPI mess. Color me not in the least 
> surprised, and it needs somebody who understands AML and what the heck is 
> supposed to happen to figure out.

Side note: we could obviously undo the commit that triggered this for you 
(ie 52ade9b3b97fd3bea42842a056fe0786c28d0555), but then we have to undo 
also the commit that caused us to do that commit in the first place, and 
change the ordering on resume too (that would be commit 
e3c7db621bed4afb8e231cb005057f2feb5db557 - the commit that moved the 
"pm_ops->finish()" call to before the call to device_resume())

In other words, we'd have to go back to our original ordering, which Len 
said was fundamentally wrong. I don't think anybody really wants that.

It would be better to figure out why "device_suspend()" apparently causes 
problems for your AML crud.

Oh, and why is linux-kernel cc'd, but not linux-pm? Are all the relevant 
people from linux-pm cc'd, or should somebody who is on that list please 
try to condense this down?

(For linux-pm: see 

        http://bugzilla.kernel.org/show_bug.cgi?id=9528

for some more details, including a few red herrings like the whole subject 
line of this email thread which turned out to not be valid after all).

		Linus
