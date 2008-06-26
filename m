Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbYFZNNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbYFZNNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbYFZNIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:08:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48121 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYFZNH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:07:58 -0400
Date: Thu, 26 Jun 2008 08:07:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 11/11] sysfs: user namespaces: fix bug with
	clone(CLONE_NEWUSER) with fairsched
Message-ID: <20080626130752.GA11002@us.ibm.com>
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.746054454@theryb.frec.bull.fr> <485F0812.4090903@gmail.com> <20080625184409.GA8353@us.ibm.com> <m1wskd43uc.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wskd43uc.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Except the sysfs mount holds no refcount on the userns.  So as long as we
> > do the ida tagging as you suggested in your response to patch 6, there
> > should be no reference to the user_ns left in sysfs code.
> >
> > The extra reference in patch #9 is for a light ref on the network
> > namespace.  I'm still not sure that needs to be there, since if the
> > network namespace goes away, it will properly unregister its sysfs
> > mounts.  Eric, Benjamin, I really don't see any use for the hold_net()
> > from sysfs.  What is it doing?
> 
> Mostly just being a sanity check.  We can remove that if it easier.
> 
> Eric

In itself it seems an ok check (temporarily) to make sure that the
net_ns hook to unset the tag.netns at netns release is properly working,
but given that it's only checking for net_ns coding errors, and Tejun
wants a whole generic hooking infrastructure for net_ns to register with
so as to keep mention of net_ns out of sysfs code, yeah I think the sane
thing is to just remove it.

But the first thing (after Daniel is finished with the patch 5 fallout)
is to address the patch 6 comments about using ida.  At first I didn't
like it (seemed like too much bookkeeping) but I think it'll actually
work out very nicely.

-serge
