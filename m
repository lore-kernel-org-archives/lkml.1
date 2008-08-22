Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYHVW5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYHVW5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYHVW4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:56:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:57772 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbYHVW4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:56:51 -0400
Date: Sat, 23 Aug 2008 08:56:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, SELinux <selinux@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: Re: [PATCH 1/1] selinux: add support for installing a dummy policy
In-Reply-To: <20080822193413.GA8401@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0808230852320.24779@tundra.namei.org>
References: <20080822193413.GA8401@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Serge E. Hallyn wrote:

> In August 2006 I posted a patch to the selinux list generating a minimal
> SELinux policy.  This week, David P. Quigley posted an updated version
> of that as a patch against the kernel.  In addition to some fixes, also
> had nice logic for auto-installing the policy.
> 
> I've gone ahead and hooked it into the kernel Makefile logic.  The way I
> have it here, doing 'make scripts' ends up compiling 'mdp', after which
> you must
> 	cd scripts/selinux
> 	sh install_policy.sh
> 
> That isn't as nice as being able to do
> 	make selinux_install
> the way David had it, but it avoids mucking with the top-level
> Makefile.  Which is preferred?

I think leaving out of the top level makefile is preferred, as there are 
no other subsystem targets there.

Please make sure 'make distclean' cleans up properly.  These are 
currently left behind:

#       scripts/selinux/mdp/file_contexts
#       scripts/selinux/mdp/policy.23
#       scripts/selinux/mdp/policy.conf

Please also provide documentation on how to boot the system up with this 
policy.


> +	echo "no file contests file.  Please run"

ITYM contexts :-)



- James
-- 
James Morris
<jmorris@namei.org>
