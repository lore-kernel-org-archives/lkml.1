Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbXIERmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbXIERmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXIERmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:42:14 -0400
Received: from ozlabs.org ([203.10.76.45]:46998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434AbXIERmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:42:12 -0400
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Rusty Russell <rusty@rustcorp.com.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com, jcm@jonmasters.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070905170831.GA25050@hmsreliant.think-freely.org>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 03:41:37 +1000
Message-Id: <1189014097.10802.174.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 13:08 -0400, Neil Horman wrote:
> On Thu, Sep 06, 2007 at 02:13:26AM +1000, Rusty Russell wrote:
> > On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> > > But I'm wondering, wouldn't module refcounting alone fix this problem?
> > > If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> > > on ip_tables.ko would simply fail because the refcount is above zero
> > > (so it would fail at point 3 above). Am I missing something important?
> > 
> > Yes, that seems the correct solution to me, too.  ISTR that this code
> > predates the current module code.
> > 
> > Rusty.
> 
> Thanks guys-
> 	When I first started looking at this problem I would have agreed with
> you, that module reference counting alone would fix the problem.  However,
> delete_module can work in either a non-blocking or a blocking mode.  rmmod
> passes O_NONBLOCK to delete module, and so is fine, but modprobe does not.

Hi Neil,

	You have this backwards: O_NONBLOCK is the default.  That seems to be
what everyone wants, although I implemented 'rmmod -w' because it seemed
like a good option.

Rusty.


