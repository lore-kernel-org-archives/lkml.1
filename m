Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZG3RwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZG3RwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZG3RwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:52:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZG3RwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:52:00 -0400
Subject: Re: [PATCH -v3 1/3] Capabilities: move cap_file_mmap to commoncap.c
From: Eric Paris <eparis@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       jwcart2@tycho.nsa.gov, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, alan@lxorguk.ukuu.org.uk,
       kees@outflux.net, csellers@tresys.com,
       penguin-kernel@i-love.sakura.ne.jp
In-Reply-To: <1248969492.11627.172.camel@moss-pluto.epoch.ncsc.mil>
References: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
	 <20090730051426.GA6082@us.ibm.com> <1248968428.2597.79.camel@localhost>
	 <20090730155403.GA13939@us.ibm.com>
	 <1248969492.11627.172.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 13:50:52 -0400
Message-Id: <1248976252.2771.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 11:58 -0400, Stephen Smalley wrote:
> On Thu, 2009-07-30 at 10:54 -0500, Serge E. Hallyn wrote:
> > Quoting Eric Paris (eparis@redhat.com):
> > > On Thu, 2009-07-30 at 00:14 -0500, Serge E. Hallyn wrote:
> > > > Quoting Eric Paris (eparis@redhat.com):
> > > > > Currently we duplicate the mmap_min_addr test in cap_file_mmap and in
> > > > > security_file_mmap if !CONFIG_SECURITY.  This patch moves cap_file_mmap
> > > > > into commoncap.c and then calls that function directly from
> > > > > security_file_mmap ifndef CONFIG_SECURITY like all of the other capability
> > > > > checks are done.
> > > > 
> > > > It also
> > > > 
> > > > 	1. changes the return value in error case from -EACCES to
> > > > 	   -EPERM
> > > > 	2. no onger sets PF_SUPERPRIV in t->flags if the capability
> > > > 	   is used.
> > > > 
> > > > Do we care about these?
> > > 
> > > Personally, not really, but I'll gladly put them back if you care.   #2
> > > seems more interesting to me than number 1.   I actually kinda like
> > > getting EPERM from caps rather than EACCES since them I know if I was
> > > denied by selinux or by caps.....
> > > 
> > > -Eric
> > 
> > Yup, I asked bc I didn't particularly care myself.
> > 
> > I think I agree with you about -EPERM being better anyway.  However I
> > (now) think in this case PF_SUPERPRIV definately should be set, as this
> > is a clear use of a capability to do something that couldn't have been
> > done without it.
> 
> On a related but different note, we should consider all current uses of
> cap_capable(), as they represent capability checks that will not be
> subject to a further restrictive check by other security modules.  In
> this case and in the vm_enough_memory case, that is intentional, but not
> so clear for other uses in commoncap.c.

Most of commoncap.c is called either as a secondary hook from the active
lsm (aka selinux calls the commoncap.c functions) or in the !
CONFIG_SECURITY case.

I'll audit this afternoon to see which of them might not fit these
rules....

-Eric

