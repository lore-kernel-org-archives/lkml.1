Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYGOWqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYGOWqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYGOWpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:45:38 -0400
Received: from mail.fieldses.org ([66.93.2.214]:33761 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911AbYGOWph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:45:37 -0400
Date: Tue, 15 Jul 2008 18:45:35 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
Message-ID: <20080715224535.GB28739@fieldses.org>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net> <20080715195333.GK21590@fieldses.org> <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net> <20080715204812.GD25803@fieldses.org> <Pine.LNX.4.64.0807151349570.18395@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807151349570.18395@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 02:16:45PM -0700, Sage Weil wrote:
> On Tue, 15 Jul 2008, J. Bruce Fields wrote:
> > I just wonder how one would explain to users (or application writers)
> > why changes to a file are reflected in the parent's rctime in one case,
> > and not in another, especially if the primary link is otherwise
> > indistinguishable from the others.  The symptoms could be a bit
> > mysterious from their point of view.
> 
> Yes.  I'm not sure it can really be avoided, though.  I'm trying to lift 
> the usual restriction of having to predefine what the 
> volume/subvolume/qtree boundary is and then disallowing links/renames 
> between then.  When all of a file's links are contained within the 
> directory you're looking at (i.e. something that might be a subvolume 
> under that paradigm), things look sensible.  If links span two directories 
> and you're looking at recursive stats for a dir containing only one of 
> them, then you're necessarily going to have some weirdness (you don't want 
> to double-count).

Yeah, there's no clear right answer--that's partly why I was curious
about rctime specifically.

--b.
