Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757464AbYLQQzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYLQQzz (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYLQQzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:55:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbYLQQzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:55:43 -0500
Subject: Re: [PATCH 3/15] sanitize audit_ipc_obj()
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
In-Reply-To: <alpine.LRH.1.10.0812172047090.24405@tundra.namei.org>
References: <E1LCoh0-00009T-Sd@ZenIV.linux.org.uk>
	 <alpine.LRH.1.10.0812171823430.22856@tundra.namei.org>
	 <20081217093245.GC28946@ZenIV.linux.org.uk>
	 <alpine.LRH.1.10.0812172047090.24405@tundra.namei.org>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 11:55:28 -0500
Message-Id: <1229532928.3384.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 20:53 +1100, James Morris wrote:
> On Wed, 17 Dec 2008, Al Viro wrote:
> 
> > On Wed, Dec 17, 2008 at 06:24:40PM +1100, James Morris wrote:
> > > On Wed, 17 Dec 2008, Al Viro wrote:
> > > 
> > > > +		struct {
> > > > +			uid_t			uid;
> > > > +			gid_t			gid;
> > > > +			mode_t			mode;
> > > > +			u32			osid;
> > > > +		} ipc;
> > > 
> > > 'osid' should be converted into 'secid' someday.
> > 
> > Eh?  Do you mean the field name there or the actual output?  Either is
> > trivial, of course, but the latter is up to userland folks and the
> > former alone seems to be rather pointless...
> 
> I was thinking in terms of the kernel API, where 'secid' is the preferred 
> name for security identifiers ('sid' being an SELinux-specific term and 
> also conflicting with 'session id').  Given that it's exposed to userland, 
> I guess it's too late.

James meant just do s/osid/secid/ for continuity across the kernel (we
are trying to make the main kernel a bit more LSM agnostic and sid is an
SELinux term).  The userspace exported part is actually a translated
string (I think we use ocontext= and scontext=).

There is no reason we couldn't do this in audit.  But, I don't think
it's worth changing this patch, as I think audit refers to it as sid in
other places.  Maybe I'll try to clean that up someday.  I at least
added it to my "someday" todo list.

-Eric

