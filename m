Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYA2GAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYA2GAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYA2GAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:00:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37875 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYA2GAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:00:19 -0500
Date: Mon, 28 Jan 2008 21:58:25 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129055825.GG23506@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20080129033307.GE23506@ca-server1.us.oracle.com> <20080129050804.GA2285@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129050804.GA2285@suse.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> > Joel Becker (1):
> >       ocfs2: Fix userspace ABI breakage in sysfs
> 
> This is fine with me, for now.

Great, thanks.


> > From: Joel Becker <Joel.Becker@oracle.com>
> > 
> > ocfs2: Fix userspace ABI breakage in sysfs
> > 
> > The userspace ABI of ocfs2's internal cluster stack (o2cb) was broken by
> > commit c60b71787982cefcf9fa09aa281fa8c4c685d557 "kset: convert ocfs2 to
> > use kset_create".  Specifically, the '/sys/o2cb' kset was moved to
> > '/sys/fs/o2cb'.  This breaks all ocfs2 tools and renders the
> > filesystem unmountable.
> > 
> > This fix moves '/sys/o2cb' back where it belongs.
> 
> "belongs" is pretty odd here.  This is a filesystem specific thing,
> right?  Why not put it in /sys/fs/ then?

We had it there before /sys/fs and as has been noted, it's ABI so we can't
change it right away. In theory, it's actually outside the fs, but in
reality it's pretty tied to Ocfs2, so I have no objection to the idea of it
being eventually moved there.


> And yes, I understand about legacy userspace tools, that's why I have no
> objection to it going back.  But you can put it in both places (with a
> symlink) and change your userspace code, and in a year or so, drop the
> symlink, right?

Yeah, that sounds entirely reasonable. It shouldn't be too hard for us to
fix up ocfs2-tools to look in both places. So long as there's enough lead
time for users to upgrade their toolchain (we can do releases for all
branches of ocfs2-tools, make annoucements on lists, etc), I think the
impact shouldn't be too bad.


> And please please please please document stuff like this, and all of the
> different files you have in this subdirectory in Documentation/ABI/ so
> those of us who are trying to figure out the code (and there's still
> parts of the kobject usage I'm pretty sure is not correct) can have a
> chance to understand exactly how this stuff is being used and expected
> to work.

No problem. I'll get us some patches to symlink things, and add docs in
Documentation/ABI/ explaining how Ocfs2 and userspace communicate. In the
future, as we add ABI it'll be documented there.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
