Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbXDJHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbXDJHoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXDJHoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:44:44 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3293 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbXDJHon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:44:43 -0400
Date: Tue, 10 Apr 2007 08:44:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410074422.GA30507@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
	Robin Holt <holt@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jack Steiner <steiner@americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409193056.6b52c354.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 07:30:56PM -0700, Andrew Morton wrote:
> : root       319  0.0  0.0      0     0 ?        S    18:51   0:00 [pccardd]
> 
> hm.

One per PC card socket to avoid the sysfs locking crappyness that would
otherwise deadlock, and to convert from the old unreadable state machine
implementation to a much more readable linearly coded implementation.

Could probably be eliminated if we had some mechanism to spawn a helper
thread to do some task as required which didn't block other helper
threads until it completes.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
