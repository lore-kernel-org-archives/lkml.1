Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZILJrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZILJrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 05:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZILJrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 05:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZILJrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 05:47:39 -0400
Subject: Re: [origin tree boot crash] Revert "selinux: clean up avc node
 cache when disabling selinux"
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090912072450.GA6767@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Sep 2009 05:46:31 -0400
Message-Id: <1252748791.2305.89.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 09:24 +0200, Ingo Molnar wrote:
> James - i did not see a security pull request email from you in my 
> lkml folder so i created this new thread. -tip testing found the 
> easy crash below. It reverts cleanly so i went that easy route.
> 
> At a really quick 10-seconds glance the crash happens because we 
> destroy the slab cache twice, if the sysctl is toggled twice?

No, it's only being free'd once (and can only be freed once since
the /selinuxfs file disappears when it happens).  It's being freed while
there are still entries in it.

This actually points out to me that SELinux was leaking memory when
disabled at run time (not when disabled from the kernel command line)
and that's the real problem.

I'll take a look at it tonight, James, if you haven't ask Linus to pull
can you hold off until I get this long standing memory leak fixed?  If
Linus already took the change we should revert and do them both again.
(This patch is right, just obviously incomplete)

-Eric

