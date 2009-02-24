Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZBXPV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZBXPV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZBXPVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:21:48 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:51822 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBXPVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:21:47 -0500
Subject: Re: New filesystem for Linux kernel
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Theodore Tso <tytso@mit.edu>
Cc: Tomas M <tomas@slax.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090224141548.GB5482@mit.edu>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl>
	 <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org>
	 <49A3AC14.2050107@slax.org>  <20090224141548.GB5482@mit.edu>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 24 Feb 2009 10:18:15 -0500
Message-Id: <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 09:15 -0500, Theodore Tso wrote:
> On Tue, Feb 24, 2009 at 09:13:08AM +0100, Tomas M wrote:
> > An overview of aufs2 has been submitted to this list.
> > I noticed zero response at all. Nobody cares?
> > 
> > I suggest to remove unionfs from Andrew's -mm tree and replace it by aufs2!
> > Tell me why this should not happen...
> 
> Um, you need to tell us why aufs2 is better than Unionfs.  The burden
> of proof rests on your shoulders.  The code which is displacing
> existing code needs to give a justification about why it is better
> than the code which is displacing, not the other way around.
> 
> > I write this in the hope that a debate will start...
> 
> As a debate judge might say, you haven't even made your prima facie
> case yet.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The arguments that the AUFS2 people have been using for a while is that
aufs2 is more stable than unionfs. I use to work on the Stony Brook
version of Unionfs and I must admit that the 1.0 version which I did the
initial 2.6 kernel port of was buggy. However after I left they rewrote
large chunks of the code for a 2.0 release. I don't have much knowledge
of this code base but I am still subscribed to the Unionfs mailing list
and I don't see too many bug reports heading that way. 

In reality though the debate isn't Unionfs vs AUFS2 because many of the
kernel people including Christoph have voiced their opinion that they
don't want to see a file system solution to union mounts. There have
been patch sets trying to introduce union mounts and they seem to have
gone quiet for a while as one of the main points of debate was how and
where to do duplicate elimination.

That being said there is no reason that both unionfs and aufs2 can't
live in mm. However, just because either of them are in mm doesn't mean
that they will get mainlined. Reiser4 has been in there for ages and I
don't think anyone sees that getting in any time soon.

As far as review of AUFS2 goes I use to idle in a few freenode channels
a while back and there was a discussion about AUFS2 the first time it
hit LKML. The AUFS people tout that the unionfs dev team has
incorporated some of their ideas into unionfs and that is true. However,
one of the issues raised about AUFS back then was that they had all
sorts of sorted hacks that were unacceptable for use in mainline. I
don't have my irc logs since I am at work and they are at home but I can
try to dig up the specific problems when I get home later today.

I think AUFS2 really needs a solid review but as other people have said
it isn't broken up and organized in a way that makes it a task someone
wants to do. Earlier in the thread someone said that the AUFS team needs
to slim it down to just core features and get those mainlined. The
Unionfs team did this when we were moving for mainline inclusion and I
think that is one of the reasons why people jumped ship and moved to
AUFS. Since we were focusing on the mainline inclusion effort and
releasing a smaller feature set Unionfs it ended up dropping some
functionality that people may have seen as core while the kernel
community and ourselves didn't.

Just my $0.02 and in no way shape or form the opinion of my employer or
the US govt and definitely not a request to have work done in this
space.

