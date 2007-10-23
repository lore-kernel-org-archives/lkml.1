Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXJWPxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXJWPxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXJWPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:52:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbXJWPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:52:56 -0400
Date: Tue, 23 Oct 2007 08:52:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Olaf Hering <olh@suse.de>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Bugfix to commit
 4f9a58d75bfe82ab2b8ba5b8506dfb190a267834
In-Reply-To: <20071023063720.GA29993@suse.de>
Message-ID: <alpine.LFD.0.999.0710230839120.30120@woody.linux-foundation.org>
References: <20071022223737.21679.23812.stgit@trillian.cg.shawcable.net>
 <20071023063720.GA29993@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Olaf Hering wrote:
>
> On Mon, Oct 22, Grant Likely wrote:
> 
> > Olaf, do I have the correct solution here?
> 
> Sure.

Side note: I already applied that patch, but take a look at the commit 
message.

That's right: I had to edit the message provided to make it readable. So 
I'll just take this opportunity to ask people that when they send 
bug-fixes, please try to make the subject line and message make sense for 
a *reader*, not for yourself (or even to me, although if it's readable to 
some generic person, it's hopefully readable to me too!).

So a subject line of "Bugfix to commit <commit-sha-goes-here>" is 
obviously not a very nice one, if you're looking at the kernel commit 
history in gitk or some other visualizer that shows the first line as the 
subject for the whole commit. It just doesn't make any sense to the 
reader!

Related to that, another thing that also happens is that people write 
subject lines (and the description) as if everybody realized that 
something is particular to that architecture or driver. It may be true 
that that particular developer (or development list) is only about ppc, 
and then people write subject lines like "Fix execve() argument handling", 
but again, when a *generic* person reads that, it now reads totally wrong, 
since it wasn't execve() in general, it was a particular architecture that 
it went wrong for.

So the rule should be:

 - if it's not fairly generic, specify the area (architecture, subsystem, 
   driver) that the fix is for in the subject line. Even if you end up 
   initially sending the fix out to just a list that handles that 
   particular subsystem anyway.

 - don't use commit names in the subject line - and while it's great to 
   use them in the body of the explanation, even there you don't want to 
   assume that people read it from within git. People see patches and 
   commit changelogs on the web or the commit mailing lists, so when 
   specifying an exact version, also specify the human-readable name of 
   that version.

 - write the commit message for an outsider, and use whitespace. The 
   third-most common fixup I end up doing (after the above two) is to 
   split things up into shorter paragraphs, after somebody wrote a good 
   changelog entry, but made it one large unreadable blob of text. The 
   more involved and technical some description is (and that's what long 
   changelog entries should be - we don't want a fluffy novella here!), 
   the more "breather space" and individually understandable small 
   snippets of text readers need. Making things too dense is bad.

Anyway, this was in no way meant to be a specific problem for Grant or 
Olaf - I end up editing just about half of all the commit messages of 
stuff I get in email (except for Andrew's stuff, since Andrew largely does 
the same kinds of cleanups anyway, so I only need to edit up a small 
percentage of the patches he forwards). I'd like it to be *much* less than 
that, so I thought I should speak up since I had an example of this.

			Linus
