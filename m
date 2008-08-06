Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbYHFBvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbYHFBvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbYHFBox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:44:53 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41504 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755198AbYHFBov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:44:51 -0400
Date: Tue, 5 Aug 2008 21:44:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Rik van Riel <riel@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
	toalinuxinterfaceforonaccess scanning
Message-ID: <20080806014435.GF8224@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rik van Riel <riel@redhat.com>, Eric Paris <eparis@redhat.com>,
	Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	"Press, Jonathan" <Jonathan.Press@ca.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org
References: <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com> <20080805214415.GA5830@kroah.com> <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com> <20080805222638.GA6395@kroah.com> <20080805233743.GK28946@ZenIV.linux.org.uk> <1217980132.27684.203.camel@localhost.localdomain> <20080806001124.GA9079@kroah.com> <1217982329.27684.214.camel@localhost.localdomain> <20080805204600.03ceca31@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805204600.03ceca31@bree.surriel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 08:46:00PM -0400, Rik van Riel wrote:
> My real worry is that the anti-virus companies have been working
> with an enforcement policy that has been evolving slowly from the
> DOS days, while today's threat model has changed considerably.

... and which also doesn't into account some of the facilities which
Linux has, that DOS/Windows does not have.

Part of the problem I suspect is that the AV folks have managed to get
CIO's believe that all computer systems need to have anti-virus
software, of the same design that is needed for DOS/Windows systems.
This state of delusion is so bad that apparently some AV engineers
aren't even willing to reason from first principles what is necessary
or not to maintain a secure system.

And arguably, if the goal is security theater, much like the security
lines in airports, perhaps it doesn't matter.  If there are silly
CIO's that are willing to pay for such a thing, regardless of whether
or not it is actually *necessary* to maintain security, one school of
capitalism would say it doesn't matter if it actually provides any
functional value or not.

On the other hand, it seems pretty clear there are plenty of LKML
developers who aren't buying it.  :-)

It may be helpful to separate the threat model into at least three
different scenarios:

	The Linux Desktop (where clueless users may be tricked into
		running malware).

	The Linux File Server (where it is *highly* unlikely to have
		active running malware, since there are no clueless
		users running on said file server), but where malware
		may be stored and read over CIFS, NFS, etc.

	The Linux Mail server is really a restricted case of the Linux
		Fileserver; where the only way in is SMTP, and the
		only protocol out is IMAP/POP.  

Clamav arguably does a very nice job for the third case.  And the
number of ways in and out for a Linux fileserver is sufficiently small
(and there are no clueless users to start the malware program
running), that it's relatively easy to reason about.

In the Linux Desktop case, you do have to worry about clueless users,
but in general you don't have to worry about serving CIFS or NFS on
such boxes.

It seems that the AV folks are trying to argue for a worst case
scenario --- one where you have a clueless user, *and* you have a root
comproise, *and* it is also simultaneously serving as a high output
fileserver.  #1, I think it is questionable whether this is a
reasonable model, and #2, if root is compromised, no amount of
scanning software will helpyou, since the malware can simply directly
attach and disable the scanning software.

But it is specifically this sort of threat analysis and explicit
detailing of the assumptions of what capabilities the attacker has
which is critical for proceeding.  The fact at least one AV engineer
thinks it's pointless to do this sort of low-level design is
disappointing.

						- Ted
