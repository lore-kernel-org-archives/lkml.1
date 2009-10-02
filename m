Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZJBK5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZJBK5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZJBK5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:57:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:41133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606AbZJBK5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:57:36 -0400
Message-ID: <4AC5DC61.9060900@kernel.org>
Date: Fri, 02 Oct 2009 19:56:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com,
       pm list <linux-pm@lists.linux-foundation.org>,
       Oren Laadan <orenl@librato.com>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-2-git-send-email-tj@kernel.org> <20091001183655.GA9995@atrey.karlin.mff.cuni.cz> <200910012304.00720.rjw@sisk.pl>
In-Reply-To: <200910012304.00720.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 10:56:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel, Rafael.

Rafael J. Wysocki wrote:
> On Thursday 01 October 2009, Pavel Machek wrote:
>>> Freezing isn't exactly the most latency sensitive operation and
>>> there's no reason to burn cpu cycles and power waiting for it to
>>> complete.  msleep(10) instead of yield().  This should improve
>>> reliability of emergency hibernation.
>> i don't see how it improves reliability, but its probably ok.

It's about battery.  When emergency hibernation kicks in and something
is taking a while to freeze (usually nfs does this for me) burning
power waiting for it to finish is a pretty bad idea.

>> Well... for hibernation anyway. I can imagine cgroup users where
>> freeze is so fast that this matters. rjw cc-ed.		pavel
> 
> Thanks.  I'd like to hear from the cgroup freezer people about that.

Oh... didn't know that.  10ms sleeps really matter there?

-- 
tejun
