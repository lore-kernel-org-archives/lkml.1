Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZG3Tl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZG3Tl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZG3Tlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:41:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36090 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZG3Tly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:41:54 -0400
Date: Thu, 30 Jul 2009 14:41:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, jwcart2@tycho.nsa.gov, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kees@outflux.net,
       csellers@tresys.com, penguin-kernel@i-love.sakura.ne.jp
Subject: Re: [PATCH -v3 1/3] Capabilities: move cap_file_mmap to commoncap.c
Message-ID: <20090730194149.GA20292@us.ibm.com>
References: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com> <20090730051426.GA6082@us.ibm.com> <1248968428.2597.79.camel@localhost> <20090730155403.GA13939@us.ibm.com> <1248976383.2771.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248976383.2771.4.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
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
> Easy enough, if I add PF_SUPERPRIV can I add your ACK?  Basically just

Yup.

> ret = cap_capable();
> if (!ret)
> 	current->flags |= PF_SUPERPRIV;
> 
> return ret;

Yup.  (Maybe spell out 'if (ret == 0)' to help people keep straight
that 0 means ok with cap_capable(), but it's up to you)

thanks,
-serge
