Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYJ3NmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYJ3NmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYJ3NmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:42:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51620 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbYJ3NmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:42:02 -0400
Date: Thu, 30 Oct 2008 08:35:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com, sgrubb@redhat.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
	inheritable capabilities
Message-ID: <20081030133541.GA4385@us.ibm.com>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222612.3895.6710.stgit@paris.rdu.redhat.com> <48FD6E49.6060104@kernel.org> <20081021191625.GA4657@us.ibm.com> <48FF21BF.9090509@kernel.org> <20081022141430.GB21612@us.ibm.com> <48FFFA07.3060707@kernel.org> <1225317519.23736.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225317519.23736.60.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Wed, 2008-10-22 at 21:13 -0700, Andrew G. Morgan wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Serge E. Hallyn wrote:
> > >>> ... except if (!issecure(SECURE_NOROOT) && uid==0) I guess?
> > >>>
> > >>> And then it also might be interesting in the case where
> > >>> (!issecure(SECURE_NOROOT) && uid==0) and pP is not full.
> > >> I guess so, although this seems like a case of being interested in a
> > >> (unusual) non-privileged execve().
> > > 
> > > I'm not sure what you mean - but this can only happen if bits are taken
> > > out of the capability bounding set, right?
> > 
> > Yes, it can happen as you say.
> > 
> > This is a case of an unprivileged uid==0 execution. Since we don't
> > appear to want to audit other non-privileged execve()s, its not clear to
> > me that this one deserves attention.
> 
> So what did you two agree on for when to collect fcaps type information?
> Any time bprm->cap_post_exec_permitted is non-zero?

And (bprm->e_uid!=0 && current->uid!=0 && !issecure(SECURE_NOROOT)) -
otherwise you'll get a hit for every file executed by root.  If you're
ok with that noise, then it's fine with me.  (I assume it can be
filtered out using an audit rule by userspace anyway?)

The inverse case that I suggested is interesting because root was
prevented from running with full capabilities - which could be
indicative of a sendmail-capabilities-bug style of attack.

-serge
