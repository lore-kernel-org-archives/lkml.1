Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbXIEQOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbXIEQOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbXIEQNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:13:52 -0400
Received: from ozlabs.org ([203.10.76.45]:42829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbXIEQNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:13:51 -0400
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Rusty Russell <rusty@rustcorp.com.au>
To: Patrick McHardy <kaber@trash.net>
Cc: Neil Horman <nhorman@tuxdriver.com>, adam@yggdrasil.com,
       jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46DEC9BF.9010807@trash.net>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 02:13:26 +1000
Message-Id: <1189008806.10802.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> But I'm wondering, wouldn't module refcounting alone fix this problem?
> If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> on ip_tables.ko would simply fail because the refcount is above zero
> (so it would fail at point 3 above). Am I missing something important?

Yes, that seems the correct solution to me, too.  ISTR that this code
predates the current module code.

Rusty.

