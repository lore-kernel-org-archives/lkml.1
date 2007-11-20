Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbXKTP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbXKTP3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbXKTP3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:29:06 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:39953 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758218AbXKTP3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:29:05 -0500
Subject: Re: [PATCH 1/4] proc: fix NULL ->i_fop oops
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, devel@openvz.org,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <20071120151731.GA20322@infradead.org>
References: <20071116150651.GC19517@localhost.sw.ru>
	 <20071119125139.GB15942@infradead.org>
	 <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil>
	 <20071120151731.GA20322@infradead.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 20 Nov 2007 10:22:37 -0500
Message-Id: <1195572157.20910.40.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 15:17 +0000, Christoph Hellwig wrote:
> On Tue, Nov 20, 2007 at 10:05:05AM -0500, Stephen Smalley wrote:
> > > Nice, getting rid of this is a very good step formwards.  Unfortunately
> > > we have another copy of this junk in
> > > security/selinux/selinuxfs.c:sel_remove_entries() which would need the
> > > same treatment.
> > 
> > Can't just be dropped completely for selinux - we need a way to drop
> > obsolete entries from the prior policy when we load a new policy.
> > 
> > Is the only real problem here the clearing of f_op?  If so, we can
> > likely remove that from sel_remove_entries() without harm, and fix the
> > checks for it to use something more reliable.
> 
> f_op removal is the biggest issue.  It can't really work and this is the
> last instance.  But in general having some half-backed attempts at revoke
> is never a good idea.

Yes, we're not trying to revoke per se, but just re-populate a set of
directories that represent elements of policy state on a policy
reload.  /selinux/booleans is one example - a directory with one entry
per policy boolean defined by the policy.  Old directory tree gets torn
down on each policy reload and replaced.

-- 
Stephen Smalley
National Security Agency

