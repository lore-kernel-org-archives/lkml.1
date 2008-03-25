Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYCYTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYCYTcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYCYTcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:32:11 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:55379 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYCYTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:32:10 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 15:32:09 EDT
Date: Tue, 25 Mar 2008 20:07:43 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <morgan@kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325190743.GA2379@MAIL.13thfloor.at>
Mail-Followup-To: "Serge E. Hallyn" <serue@us.ibm.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Emelyanov <xemul@openvz.org>,
	Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
	Chris Wright <chrisw@sous-sol.org>,
	Andrew Morgan <morgan@kernel.org>,
	Linux Containers <containers@lists.osdl.org>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <1206446637.3302.134.camel@moss-spartans.epoch.ncsc.mil> <20080325134001.GB5984@sergelap.austin.rr.com> <1206455835.3302.185.camel@moss-spartans.epoch.ncsc.mil> <20080325180611.GB19176@sergelap.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325180611.GB19176@sergelap.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 01:06:11PM -0500, Serge E. Hallyn wrote:
> Quoting Stephen Smalley (sds@tycho.nsa.gov):
> > 
> > On Tue, 2008-03-25 at 08:40 -0500, Serge E. Hallyn wrote:
> > > Quoting Stephen Smalley (sds@tycho.nsa.gov):
> > > > 
> > > > On Tue, 2008-03-25 at 02:04 +0300, Oleg Nesterov wrote:
> > > > > On 03/24, Pavel Machek wrote:
> > > > > >
> > > > > > > /sbin/init is important, but there are other important (and sometimes
> > > > > > > much more important) services. Why it is so special so that we can't
> > > > > > > debug/strace it?
> > > > > > 
> > > > > > Maybe. Let's kill /sbin/init protection in 2.6.26. But making it
> > > > > > optional is wrong.
> > > > > 
> > > > > You are right, the boot parameter is silly. How about sysctl?
> > > > > 
> > > > > Stephen, do you see any security problems if we make /sbin/init
> > > > > ptraceable by default?
> > > > 
> > > > Not an issue for SELinux (we apply an orthogonal check based on security
> > > > context, so we can already block ptrace of init independent of whether
> > > > root/CAP_SYS_PTRACE can do it).  I'm not sure though as to whether
> > > > people using capabilities have ever relied on this special protection of
> > > > init (e.g. custom init spawns children with lesser capabilities and
> > > > relies on the fact that they cannot ptrace init to effectively re-gain
> > > > those capabilities, even if they possess CAP_SYS_PTRACE).
> > > 
> > > Still thinking it through, but it seems like special casing init isn't
> > > useful.  There are likely to be other tasks with all capabilities
> > > set which the malicious task could just as well ptrace to do his
> > > mischief, right?
> > 
> > Depends on the bounding set.  Didn't it used to be the case that only
> > init had CAP_SETPCAP (until the meaning of it was changed by the
> > filesystem capability support)?
> 
> Not quite.  CAP_SETPCAP was taken out of everyone's bounding set.  But
> kernel/sysctl.c allowed only init to add capabilities to the bounding
> set.  (Whereas CAP_SYS_MODULE was sufficient to remove them).
> 
> > Might want to double check with e.g. the vservers folks that they
> > weren't relying in any way on special handling of init.
> 
> Herbert, Pavel, do you have objections to allowing ptrace of init?
> (I believe Eric has already Acked the idea iirc?)

inside a guest, by default no (i.e. there simply is
no capability for that), on the host the behaviour is
unmodified .. note that there are guests without init
where the blend through init is protected in a special
way

HTH,
Herbert

> thanks,
> -serge
