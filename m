Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYAUDDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYAUDDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 22:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYAUDD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 22:03:27 -0500
Received: from ozlabs.org ([203.10.76.45]:37754 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYAUDD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 22:03:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] rcu: fix section mismatch
Date: Mon, 21 Jan 2008 11:38:38 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, dipankar@in.ibm.com,
       akpm <akpm@linux-foundation.org>
References: <20080119115643.43236e70.randy.dunlap@oracle.com> <20080119212549.GD29070@uranus.ravnborg.org>
In-Reply-To: <20080119212549.GD29070@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211138.38591.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 January 2008 08:25:49 Sam Ravnborg wrote:
> On Sat, Jan 19, 2008 at 11:56:43AM -0800, Randy Dunlap wrote:
> > rcu_online_cpu() should be __cpuinit instead of __devinit.
>
> So if we have:
> CONFIG_HOTPLUG=n
> CONFIG_HOTPLUG_CPU=y
>
> then this is a oops candidate.

At first glance, this can't happen because all CONFIG_HOTPLUG_CPU depends on 
CONFIG_HOTPLUG or selects it, for all archs.

But CONFIG_PM_SLEEP_SMP selects CONFIG_HOTPLUG_CPU, without requiring 
CONFIG_HOTPLUG: turning on SUSPEND or HIBERNATION does this.

Perhaps it's time to revisit reverse-depends for select?

Cheers,
Rusty.
