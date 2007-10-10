Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXJJMSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXJJMSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXJJMSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:18:12 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:46575 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559AbXJJMSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:18:11 -0400
Subject: Re: [PATCH 1/6] SELinux: change Kconfig to use select instead of
	depends
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071009162812.00e80a0c.randy.dunlap@oracle.com>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
	 <Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au>
	 <20071009162812.00e80a0c.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 10 Oct 2007 08:12:30 -0400
Message-Id: <1192018350.2687.16.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 16:28 -0700, Randy Dunlap wrote:
> On Wed, 10 Oct 2007 09:19:55 +1000 (EST) James Morris wrote:
> 
> > From: Eric Paris <eparis@redhat.com>
> > 
> > Changes the security/selinux/Kconfig to use select instead of depends
> > for most of the SELinux requirements.  This allows the SELinux option to
> > show up when people do a make config without already knowing they had to
> > enable audit and other non-obvious choices.  Added a depends on SECURITY
> > (which previously existed through SECURITY_NETWORK) so that SELinux
> > would not always show up, but would be easy and intuitive to find.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> > Signed-off-by: James Morris <jmorris@e.namei>
> > ---
> >  security/selinux/Kconfig |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
> > index b32a459..40b97e6 100644
> > --- a/security/selinux/Kconfig
> > +++ b/security/selinux/Kconfig
> > @@ -1,6 +1,10 @@
> >  config SECURITY_SELINUX
> >  	bool "NSA SELinux Support"
> > -	depends on SECURITY_NETWORK && AUDIT && NET && INET
> > +	depends on SECURITY
> > +	select SECURITY_NETWORK
> > +	select AUDIT
> > +	select NET
> > +	select INET
> >  	select NETWORK_SECMARK
> >  	default n
> >  	help
> 
> I doth protest.  Enabling the entire NET subsystem thru a hidden
> select is awful.  Select should be used (sparingly) to enable
> library code only.  If someone wants NET enabled, they should
> enable it overtly, not covertly.

Does that apply to all the options, or only to NET (e.g. is it ok to
select AUDIT)?  I thought that this patch came out of earlier
discussions about proper use of select vs. depends.  It may have gone
too far, but I'm not sure it should be discarded entirely.

> 
> 
> > @@ -9,6 +13,7 @@ config SECURITY_SELINUX
> >  	  You can obtain the policy compiler (checkpolicy), the utility for
> >  	  labeling filesystems (setfiles), and an example policy configuration
> >  	  from <http://www.nsa.gov/selinux/>.
> > +
> >  	  If you are unsure how to answer this question, answer N.
> >  
> >  config SECURITY_SELINUX_BOOTPARAM
> 
> 
> 
> ---
> ~Randy
-- 
Stephen Smalley
National Security Agency

