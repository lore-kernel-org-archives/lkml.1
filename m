Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbYA1Wby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbYA1Wby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYA1Wbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:31:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47551 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYA1Wbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:31:44 -0500
Date: Mon, 28 Jan 2008 15:31:42 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080128223141.GA31101@parisc-linux.org>
References: <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128204431.GA15227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 12:44:31PM -0800, Greg KH wrote:
> On Mon, Jan 28, 2008 at 01:32:06PM -0500, Tony Camuso wrote:
> > Greg,
> >
> > Have you given Grant's suggestion any further consideration?
> >
> > I'd like to know how the MMCONFIG issues discussed in this thread are going
> > to be handled upstream. I have a patch implemented in RHEL 5.2, but I would
> > rather have the upstream patch implemented, whatever it is.
> 
> Well, everyone still doesn't seem to agree on the proper way forward
> here, so for me to just "pick one" isn't very appropriate.
> 
> So, can we try again?
> 
> Can people submit, what they think the change should be?  Right now I
> have Arjan's patch in my kernel tree, but will not send it to Linus for
> .25 for now, unless everyone thinks that is the best solution at the
> moment (which, for me, I'm leaning toward right now...)

My opinion is that Ivan's patch followed by my patch is the best way
forward.  I see Arjan's patch as a good prototype, but it introduces a lot
of unnecessary infrastructure (and a userspace interface that I dislike).

I would like to see Ivan's patch merged ASAP as it does fix one of
my machines.  akpm has the patch from me to disable io decoding, and
intends to send it to Linus during this merge window ... that patch
becomes unnecessary if we merge Ivan's patch.

My patch is an incremental improvement that adds some of the features
of Arjan's patch without the extra infrastructure.  I don't think it's
urgent, but it does make some of our internal interfaces cleaner.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
