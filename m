Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbYGOVSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbYGOVSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbYGOVQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:16:47 -0400
Received: from cobra.newdream.net ([66.33.216.30]:56955 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762350AbYGOVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:16:46 -0400
Date: Tue, 15 Jul 2008 14:16:45 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-Reply-To: <20080715204812.GD25803@fieldses.org>
Message-ID: <Pine.LNX.4.64.0807151349570.18395@cobra.newdream.net>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
 <20080715195333.GK21590@fieldses.org> <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
 <20080715204812.GD25803@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, J. Bruce Fields wrote:
> I just wonder how one would explain to users (or application writers)
> why changes to a file are reflected in the parent's rctime in one case,
> and not in another, especially if the primary link is otherwise
> indistinguishable from the others.  The symptoms could be a bit
> mysterious from their point of view.

Yes.  I'm not sure it can really be avoided, though.  I'm trying to lift 
the usual restriction of having to predefine what the 
volume/subvolume/qtree boundary is and then disallowing links/renames 
between then.  When all of a file's links are contained within the 
directory you're looking at (i.e. something that might be a subvolume 
under that paradigm), things look sensible.  If links span two directories 
and you're looking at recursive stats for a dir containing only one of 
them, then you're necessarily going to have some weirdness (you don't want 
to double-count).

Making the primary/remote-ness visible to users somehow (via, say, a 
virtual xattr) might help a bit.  The bottom line, though, is that links 
from multiple points in the namespace and a hierarchical view of file 
_content_ aren't particularly compatible concepts...

sage
