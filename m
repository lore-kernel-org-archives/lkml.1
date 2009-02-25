Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbZBYP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbZBYP5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZBYP5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:57:22 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:47814 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754AbZBYP5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:57:20 -0500
Subject: Re: New filesystem for Linux kernel
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hooanon05@yahoo.co.jp
Cc: Theodore Tso <tytso@mit.edu>, Tomas M <tomas@slax.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <14799.1235490088@jrobl>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl>
	 <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org>
	 <49A3AC14.2050107@slax.org> <20090224141548.GB5482@mit.edu>
	 <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil>
	 <14799.1235490088@jrobl>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 25 Feb 2009 10:53:34 -0500
Message-Id: <1235577214.15148.77.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 00:41 +0900, hooanon05@yahoo.co.jp wrote:
> Hi David,
> I'm glad if you remember me still.
> 
> "David P. Quigley":
> > In reality though the debate isn't Unionfs vs AUFS2 because many of the
> > kernel people including Christoph have voiced their opinion that they
> > don't want to see a file system solution to union mounts. There have
> > been patch sets trying to introduce union mounts and they seem to have
> > gone quiet for a while as one of the main points of debate was how and
> > where to do duplicate elimination.
> 
> As I wrote in aufs2 documents, UnionMount may eliminate some
> duplication, but it won't be able to share branches.
> ----------------------------------------------------------------------
> UnionMount's approach will be able to small, but may be hard to share
> branches between several UnionMount since the whiteout in it is
> implemented in the inode on branch filesystem and always
> shared. According to Bharata's post, readdir does not seems to be
> finished yet.
> ----------------------------------------------------------------------
> 
> Anyway, "kernel people including Christoph have voiced their opinion
> that they don't want to see a file system solution to union mounts" is
> very impotant. If it is true, I should ask its reason fist. Could you
> tell me the source of this information? Url of mail archive or somthing?

I'm having a hard time finding a long descriptive email from Christoph
outlining why but from our original unionfs posting to lkml this was
what I found. There have been subsequent comments from various people to
this effect as well.

http://marc.info/?l=linux-kernel&m=116833670823190&w=2

"And unionfs is the wrong thing do use for this.  Unioning is a complex
namespace operation and needs to be implemented in the VFS or at least
needs a lot of help from the VFS.  Getting namespace cache coherency
and especially locking right is impossible with out that."

I'd suggest getting the VFS maintainers to chime in on your code. If
their opinion on this has changed then you are in much better shape for
getting AUFS2 merged.

> 
> 
> > As far as review of AUFS2 goes I use to idle in a few freenode channels
> > a while back and there was a discussion about AUFS2 the first time it
> > hit LKML. The AUFS people tout that the unionfs dev team has
> > incorporated some of their ideas into unionfs and that is true. However,
> > one of the issues raised about AUFS back then was that they had all
> > sorts of sorted hacks that were unacceptable for use in mainline. I
> 
> I am afraid you are confusing aufs1 and aufs2.
> And I hope that such "unacceptable" things are dropped from aufs2.

I believe I am and since that is the case then aufs2 really needs a
solid review before it is merged. Silence isn't tacit acceptance that
the code is good to go. It usually means the people aren't looking at
it. 

> 
> 
> > don't have my irc logs since I am at work and they are at home but I can
> > try to dig up the specific problems when I get home later today.
> 
> Ok, I'll wait.

This may sound like a copout but unfortunately it seems my logs were on
my hard drive that died a few months back. Regardless though since you
did a major rewrite for AUFS2 those comments could possibly no longer be
valid. Regardless since there was a major rewrite since your last review
several people should review the code base.

> 
> 
> J. R. Okajima

All that said good luck with this effort.

