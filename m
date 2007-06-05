Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXFEV3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXFEV3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbXFEV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:29:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084AbXFEV3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:29:00 -0400
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       chrisw@redhat.com, sds@tycho.nsa.gov, sgrubb@redhat.com
In-Reply-To: <20070605211616.GE23291@devserv.devel.redhat.com>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>
	 <20070603205653.GE25869@devserv.devel.redhat.com>
	 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
	 <1181075666.3978.31.camel@localhost.localdomain>
	 <Line.LNX.4.64.0706051658170.23379@d.namei>
	 <20070605211616.GE23291@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 17:28:47 -0400
Message-Id: <1181078927.3978.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 17:16 -0400, Alan Cox wrote:
> On Tue, Jun 05, 2007 at 05:00:51PM -0400, James Morris wrote:
> > This should be an unsigned long.
> > 
> > I wonder if the default should be for this value to be zero (i.e. preserve 
> > existing behavior).  It could break binaries, albeit potentially insecure 
> 
> Agreed - DOSemu type apps and lrmi need to map at zero for vm86

While I understand, there are a few users who will have problems with
this default are we really better to not provide this defense in depth
for the majority of users and let those with problems turn it off rather
than provide no defense by default?  I could even provide a different
default for SELinux and non-SELinux if anyone saw value in that?  But if
others think that off default is  best I'll send another patch shortly
with the unsigned long fix and the default set to 0.  My hope is then
that distros will figure out to turn this on.

-Eric

