Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYIQVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYIQVY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYIQVYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:24:47 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:39860 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYIQVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:24:46 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #11500] /proc/net bug related to selinux
Date: Wed, 17 Sep 2008 17:24:36 -0400
User-Agent: KMail/1.9.9
Cc: Stephen Smalley <sds@tycho.nsa.gov>, jmorris@namei.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, netdev@vger.kernel.org
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil> <20080917125053.1f9ecf37.akpm@linux-foundation.org>
In-Reply-To: <20080917125053.1f9ecf37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171724.36269.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 3:50:53 pm Andrew Morton wrote:
> On Mon, 15 Sep 2008 09:05:26 -0400
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > However, the most likely explanation is simply that when /proc/net
> > was changed from being a directory to being a symlink to
> > /proc/self/net, that introduced an additional permission check on
> > accesses of /proc/net/<whatever>, namely the read check on the
> > symlink itself. And since that check wasn't happening on /proc/net
> > accesses with older kernels, older policies didn't allow it.
> >
> > As to why others haven't reported it, I expect that they have
> > updated their policies to newer ones that allow the necessary
> > access.  The fact that legacy distros wouldn't have such updated
> > policies isn't surprising - they don't push updates to those
> > distros for new kernels.  FC5 and FC6 are both EOL'd, right?
> >
> > In any event, we didn't change anything in SELinux - the change was
> > elsewhere (in the proc/net implementation).  Don't blame the
> > messenger please.
>
> Vanilla FC5 broke and vanilla FC6 broke.  Did vanilla FC7, 8 or 9
> break?
>
> http://smolt.fedoraproject.org/static/stats/stats.html shows
> 11,000-odd people running FC5 and FC6.  It would be incautious to
> assume that all those people have updated their selinux rules.
>
> And _requiring_ people to update their selinux rules to fix a
> kernel-caused regression is a pretty big deal for some people, I
> expect.

Just so I'm clear on the context of the problem, it sounds like if a FC5 
(I'm limiting myself to FC5 for the moment) user upgraded to a recent 
(2.6.25+) kernel (non-distro supplied in the case of FC5) then they 
will run into problems unless they also upgrade their SELinux policy, 
yes?

If that is the case I'm not sure it is really that big of a deal.  Maybe 
I'm in the minority here, but in my mind once you step away from the 
distro supplied kernel (also applies to other packages, although those 
are arguably less critical) you should also bear the responsibility to 
make sure you upgrade/tweak/install whatever other bits need to be 
fixed.

> Then again, given that this regression has been out there since
> 2.6.25, I guess not too many people are hurting from it.  But we
> suck.

We suck?  Maybe, but some explanation about why we suck in this 
particular case would be helpful as far as I'm concerned.  I don't 
really care about identifying the guilty suckees, I'm more interested 
in finding out what happened to cause us to suck because of this.

-- 
paul moore
linux @ hp
