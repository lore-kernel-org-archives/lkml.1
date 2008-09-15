Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYIOWCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYIOWCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYIOWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:02:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbYIOWCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:02:12 -0400
Date: Mon, 15 Sep 2008 18:01:30 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>
Subject: Re: 2.6.27-rc5-mm1
Message-ID: <20080915180130.10995b90@cuia.bos.redhat.com>
In-Reply-To: <20080904224004.d3dd3076.akpm@linux-foundation.org>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 22:40:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.27-rc5/2.6.27-rc5-mm1/

The bnx2 driver has stopped working on 2.6.27-rc5-mm1.

Plain 2.6.27-rc5 works.  Reversing the bnx2 changes in -mm1 does not
fix the issue, so something less obvious is going on.

# ifup eth0
Determining IP information for eth0...SIOCSIFFLAGS: Invalid argument
SIOCSIFFLAGS: Invalid argument
SIOCSIFFLAGS: Invalid argument
# ifconfig eth0 up
SIOCSIFFLAGS: Invalid argument

Bringing up the interface fails with -EINVAL.  Specifically, the
SIOCSIFFLAGS ioctl is returning -EINVAL:

ioctl(4, SIOCSIFFLAGS, 0x7fffc841cc40)  = -1 EINVAL (Invalid argument)

I am running an x86-64 kernel on a Dell pe1950 with these network chips
on the mainboard:

05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)

-- 
All Rights Reversed
