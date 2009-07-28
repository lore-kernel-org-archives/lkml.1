Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZG1QHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZG1QHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZG1QH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:07:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:32961 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZG1QH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:07:28 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 12:07:28 EDT
Date: Tue, 28 Jul 2009 08:56:22 -0700
From: Kees Cook <kees@ubuntu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
       James Carter <jwcart2@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>,
       spender@grsecurity.net, Daniel J Walsh <dwalsh@redhat.com>,
       cl@linux-foundation.org, Arjan van de Ven <arjan@infradead.org>,
       Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090728155622.GO7316@outflux.net>
References: <1248132223.2654.278.camel@localhost>
 <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org>
 <1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil>
 <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org>
 <20090728011943.589176cb@lxorguk.ukuu.org.uk>
 <87zlapgo2u.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlapgo2u.fsf@basil.nowhere.org>
Organization: Ubuntu
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:21:29AM +0200, Andi Kleen wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > A dumb question perhaps, but while addling my brain over the tty layer I
> > was wondering if for the specific case of jump through NULL (which seems
> > to be the most common but by no means only problem case that gets
> > exploited) is there any reason we can't set a default breakpoint for
> 
> You mean a hardware breakpoint? Hardware break points are a precious
> scarce resource. The people who rely on them would be likely
> unhappy if you take one way from them.

Could the page table flags be used to mask this region?  i.e. force
PROT_NONE (with the "desired" flags stored elsewhere) and in the segv
handler check if it is kernel or user space, and then fix-up the flags and
continue if it's userspace?  (I really don't know the internals on this,
but it would need to restore PROT_NONE on task-switch or something...)

-Kees

-- 
Kees Cook
Ubuntu Security Team
