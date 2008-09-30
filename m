Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYI3Ob4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYI3Ob4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYI3Obs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:31:48 -0400
Received: from tundra.namei.org ([65.99.196.166]:40234 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYI3Obs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:31:48 -0400
Date: Wed, 1 Oct 2008 00:23:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, morgan@kernel.org,
       serue@us.ibm.com, selinux@tycho.nsa.gov
Subject: Re: [PATCH] capability: WARN when invalid capability is requested
 rather than BUG/panic
In-Reply-To: <1222782946.28251.63.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0810010008130.2068@tundra.namei.org>
References: <1222782946.28251.63.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Eric Paris wrote:

> This patch adds a WARN_ONCE() to cap_capable() so we will stop
> dereferencing random spots of memory and will cleanly tell the obviously
> broken driver that it doesn't have that ridiculous permissions.  No idea
> if the driver is going to handle EPERM but anything that calls capable
> and doesn't expect a denial has got to be the worst piece of code ever
> written.....  I could return EINVAL, but I think its clear that noone
> has capabilities over 64 so clearly they don't have that permission.
> 
> This 'could' be considered a regression since 2.6.24.  Neither SELinux
> nor the capabilities system had a problem with ginormous request values
> until we got 64 bit support, although this is OBVIOUSLY a bug with the
> out of tree closed source driver....

An issue here is whether we should be adding workarounds in the mainline 
kernel for buggy closed drivers.  Papering over problems rather than 
getting them fixed does not seem like a winning approach.  Especially 
problems which are unexpectedly messing with kernel security APIs.

Also, won't this encourage vendors of such drivers to continue with this 
behavior, while discouraging those vendors who are doing the right thing?

Do we know if this even really helps the user?  For all we know, the 
driver may simply crash differently with an -EPERM.



- James
-- 
James Morris
<jmorris@namei.org>
