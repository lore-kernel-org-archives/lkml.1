Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbXFFMTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbXFFMTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762309AbXFFMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:18:54 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:63453 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933347AbXFFMSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:18:53 -0400
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
From: Stephen Smalley <sds@tycho.nsa.gov>
To: russell@coker.com.au
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, Alan Cox <alan@redhat.com>, drepper@redhat.com,
       roland@redhat.com, arjan@infradead.org, mingo@elte.hu,
       viro@zeniv.linux.org.uk, jmorris@namei.org, chrisw@redhat.com,
       sgrubb@redhat.com
In-Reply-To: <200706061902.05786.russell@coker.com.au>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>
	 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
	 <1181075666.3978.31.camel@localhost.localdomain>
	 <200706061902.05786.russell@coker.com.au>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 06 Jun 2007 08:18:29 -0400
Message-Id: <1181132309.3699.4.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 19:01 +1000, Russell Coker wrote:
> On Wednesday 06 June 2007 06:34, Eric Paris <eparis@redhat.com> wrote:
> > This patch uses a new SELinux security class "memprotect."  Policy
> > already contains a number of allow rules like  a_t self:process *
> > (unconfined_t being one of them) which mean that putting this check in
> > the process class (its best current fit) would make it useless as all
> 
> I think it would be best to use the process class and change the "*" rules to 
> ~{ memprotect }.

Eric originally used process class, but I asked him to put it into a
separate class.  I think that current refpolicy actually doesn't have
any allow a_t self:process *; rules because we already had to refactor
all such rules when we introduced execmem and friends, but that doesn't
mean that there are not legacy policies with such rules, and I'd prefer
to isolate especially security-sensitive permissions in distinct classes
(and we are running out of room in process class).

-- 
Stephen Smalley
National Security Agency

