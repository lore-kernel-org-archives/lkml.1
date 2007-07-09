Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbXGISL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbXGISL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbXGISLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:11:20 -0400
Received: from THUNK.ORG ([69.25.196.29]:51185 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbXGISLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:11:19 -0400
Date: Mon, 9 Jul 2007 14:10:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: holzheu@linux.vnet.ibm.com, randy.dunlap@oracle.com, jack@suse.cz,
       kenistoj@us.ibm.com, heiko.carstens@de.ibm.com, pavel@ucw.cz,
       hpa@zytor.com, jengelh@computergmbh.de, sam@ravnborg.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       lf_kernel_messages@linux-foundation.org, tim.bird@am.sony.com,
       arjan@infradead.org, auke-jan.h.kok@intel.com, Valdis.Kletnieks@vt.edu,
       gregkh@suse.de, linux-kernel@vger.kernel.org, joe@perches.com,
       Andrew Morton <akpm@linux-foundation.org>, hansendc@us.ibm.com,
       davem@davemloft.net
Subject: Re: [Lf_kernel_messages] Re: Documentation of kernel messages (Summary)
Message-ID: <20070709181007.GA2343@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, holzheu@linux.vnet.ibm.com,
	randy.dunlap@oracle.com, jack@suse.cz, kenistoj@us.ibm.com,
	heiko.carstens@de.ibm.com, pavel@ucw.cz, hpa@zytor.com,
	jengelh@computergmbh.de, sam@ravnborg.org, mtk-manpages@gmx.net,
	schwidefsky@de.ibm.com, lf_kernel_messages@linux-foundation.org,
	tim.bird@am.sony.com, arjan@infradead.org, auke-jan.h.kok@intel.com,
	Valdis.Kletnieks@vt.edu, gregkh@suse.de,
	linux-kernel@vger.kernel.org, joe@perches.com,
	Andrew Morton <akpm@linux-foundation.org>, hansendc@us.ibm.com,
	davem@davemloft.net
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org> <1182779321.7142.15.camel@localhost.localdomain> <200706251144.48658.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251144.48658.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:44:45AM -0400, Rob Landley wrote:
> Personally?  No to the second question, which renders the first "do it 
> yourself outside of the tree".
> 
> Just a guess, and I don't speak for anyone else here, but I think most of us 
> are waiting to see how long it takes you to lose interest.

Actually, at a brainstorming session at the recent Linux Foundation
collaboration summit, there were a number of kernel developers,
including James Bottomley, Greg K-H, Cristoph Hellwig (I think), and
others, who were actually generally symapthetic to the idea, if done
right.

The idea that was tossed about was essentially printk hashes (hashed
on message plus filename, with optional reporting of filename+line
number), with the messaging catalog being maintained externally.  Yes,
that will be a major pain for whoever wants to do the translation ---
but it puts the onus on the people who would be getting the value for
this to do the work.

The other idea that was tossed about was that for subsystems that are
using structured reporting (i.e., dev_printk, and sdev_printk in the
SCSI subsystem --- guess who suggested that :-), that there is an
opportunity to push a lot more information out to userspace for people
who want to use this facility to more easily determine when something
has bad happened to a particular disk device, for example.  This goes
a little a beyond the original stated desire for translation support,
but it was another idea to explore.

> I find "document messages" to be a horrible idea conceptually, because I think 
> the messages should _be_ documentation.  If the message is unclear it should 
> be clarified.  "There's too much garbage on the floor, we should laminate it 
> so we can't smell it anymore."  Er, no...

There are two separable desires being addressed here.  The first is
"cute" messages such as "lp0: on fire".  Yes, maybe those should be
fixed, but sometimes kernel developers *like* cute messages.  (Sniff,
I'm pretty sure there used to be a "eaten by a grue" printk, but it
doesn't seem to be there any more.  :-) Fixing these is largely a
political problem: "of course printer on fire makes sense".

The second desire is where people want entire paragraphs discsusing
possible causes of the messages and recommended responses to be
carried out by the data center's 3rd shift operations guy (aka "tape
monkey").  That's not something you *ever* want to put in the kernel,
and who ever compiles such a long document will probably sell it for
$$$ as significant value add.  Which is fine, because it is going to
cost a lot of $$$ to keep it up to date.  :-)

> > printk hashes:
> > - Additional preprocessor step needed
> 
> Only for you guys.  Those of us building our own kernels and NOT translating 
> them or producing "the big book of explanations of kernel messages for IBM 
> customers who don't understand them" shouldn't have to run this preprocessor 
> step.

Yep, I suspect it will only be used by distro kernels.  I probably
wouldn't turn it on myself.  :-)

> > - Hard to keep printks and descriptions up-to-date. If using hashes,
> >   each typo fix in a printk breaks the link to your documentation.
> > - Since the developer knows the meaning of a printk best, he probably
> >   would be the right person to write the description.
> 
> Imposing additional requirements on developers isn't going to work unless you 
> reject patches from developers who don't follow your procedures and submit 
> the appropriately filled-out forms with each patch for processing by the 
> central bureaucracy.

Yep, it's going to be up to the translators to keep the message
catalogs up to date.  The gettext folks have figured out ways of doing
fuzzy string matches, and so if you keep the external database of
filename, line #, string, hash, and translation(s), when you go to new
version of the kernel, it's not that hard to make the fuzzy
translations work.

	       	       	    	     - Ted
