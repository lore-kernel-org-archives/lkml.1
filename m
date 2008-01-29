Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYA2VW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYA2VW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYA2VWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:22:48 -0500
Received: from c60.cesmail.net ([216.154.195.49]:49142 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYA2VWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:22:47 -0500
Subject: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org
Cc: Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 16:22:45 -0500
Message-Id: <1201641765.18773.35.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

It have come to my attention that a patch has been committed to the
kernel with the explicit purpose of tainting ndiswrapper - the kernel
module allowing Windows NDIS drivers for Ethernet and Wireless cards to
be used by the kernel.

That's the commit in question:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9

It is not the first time it has happened.  The same was done in October
2006.  A heated discussion ensued, and the patch was reverted as
erroneous.  For those wishing to refresh their memories, this LWN story
would be a great starting point:

http://lwn.net/Articles/205644/

I'd like to see this mistake to be fixed without lengthy arguments this
time around.

Just to reiterate some points from the old discussion:

- ndiswrapper is licensed under GPL

- ndiswrapper needs GPL-only symbols

- tainting ndiswrapper denies its access to GPL-only symbols

- denying ndiswrapper access to GPL-only symbols is unfair and not based
on any copyright law

- denying ndiswrapper access to GPL-only symbols makes it impossible for
ndiswrapper to function

- no copyright violation is involved, as Windows drivers are not derived
from Linux sources

- Windows drivers don't call GPL-only symbols directly; ndiswrapper
stands in the middle and sanitizes the access

- it's a fair game to taint the kernel in some way if ndiswrapper has
been loaded at some point, since tainting per se is just an indicator
that the kernel has been used in an unsupportable way

- if this change stands, ndiswrapper will be renamed, which would only
create more confusion and would thus defeat the purpose of tainting

- ndiswrapper is used by kernel developers to create native drivers

- ndiswrapper is a stepping stone towards a completely free OS; take it
away and see less users, less testers and less reverse engineering
efforts

-- 
Regards,
Pavel Roskin
