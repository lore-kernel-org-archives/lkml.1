Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbYI3HGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbYI3HGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYI3HGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:06:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:48517 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752003AbYI3HGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:06:36 -0400
Date: Tue, 30 Sep 2008 09:06:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0809300859590.4022@jikos.suse.cz>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Linus Torvalds wrote:

> > Intel is working with us on tracking down and resolving the issue, but 
> > this is not going as well as one would like to see (one attempt, one 
> > card with completely hosed EEPROM contents ... and restoring the 
> > contents is not *that* trivial).
> What's the magic to trigger it? I've got a laptop with that e1000e chip 
> in it, and am obviously running a recent kernel on it. Do people have a 
> handle on it? Is it actually verified to be kernel-related, and not 
> related to the X server etc?

So far it seems to be that you need 1) something close to xorg 7.4 and 
2) 2.6.27-rcX kernel to trigger it. Not every system having e1000e is 
affected.

Apparently it is some kind of race, as it usually takes multiple cycles to 
trigger (on one of our testing machines this took three attempts to 
trigger for the first time, and then after unbricking the machine and 
restarting testing, the reproduction tests have been running for several 
hours).

It always seems to happen when X is probing/initializing the graphics 
card. So it really seems to be some badness in Xorg intel driver 
initialization code, and kernel/hardware allows bad things to happen.

Last time I heard, our X developers are suspecting vbeinit initialization 
code in Intel driver and are looking into it.

Also, we are going to release next opensuse/SLES beta with patches that 
should mitigate the problem (Jesse has posted a new version of them), so 
hopefully we will then receive some stacktraces from the users who are 
able to trigger the problem more easily.

-- 
Jiri Kosina
SUSE Labs
