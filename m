Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYE1UO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYE1UO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYE1UOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:14:39 -0400
Received: from sous-sol.org ([216.99.217.87]:38330 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYE1UOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:14:37 -0400
Date: Wed, 28 May 2008 13:14:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sysctl: permission check based on capability not euid
Message-ID: <20080528201400.GG30402@sequoia.sous-sol.org>
References: <20080528121200.54c04b5a@speedy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528121200.54c04b5a@speedy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Hemminger (stephen.hemminger@vyatta.com) wrote:
> This patch modifies the permission checks for sysctl's from being based on uid=0 (root)
> to use the capability system. This matches the behavior of other OS's using sysctl's
> and capabilities. Linux has tried to get away from using uid=0 for security overrides
> and use capabilities instead. 
> 
> I was working on Quagga enhancement that involved enabling a sysctl, and it didn't
> work because is a safe daemon and drops privileges and resets its real/effective uid
> after initialization; it then re-enables only the capabilities when it needs to
> do some privileged operation. This wouldn't work because sysctl's were still using
> the root based permission check. The existing code in quagga to enable ip forwarding
> doesn't work for the same reason.

I don't think CAP_SYS_ADMIN makes sense for net.*, for example.
