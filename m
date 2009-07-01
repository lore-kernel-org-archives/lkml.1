Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZGAP1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZGAP1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZGAP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:26:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53323 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZGAP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:26:51 -0400
Date: Wed, 1 Jul 2009 11:26:40 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: oleg@redhat.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       akpm@linux-foundation.org, earl_chew@agilent.com, nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v5)
Message-ID: <20090701152640.GD29601@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622172818.GB14673@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, version 5 of this patchset.  The frist two patches are identical.  The
second two have some minor cleanups

Change notes:

1) Patch 3 has the wait_for_dump_helper modified a bit to remove the ISFIFO
check.  Instead, we use the ispipe test in do_coredump.

2) wait_for_dump_helpers is modified slightly to move the readers/writers
modification outside of the while loop, so we don't have to constantly churn
those values.

3) Augment the test to call wait_for_dump_helpers to include a non-zero check on
core_pipe_limit.  This restores the documented sysctl behavior that I intended,
which only allows for waiting on processes when core_pipe_limit is non-zero.

Patches Follow
Neil

