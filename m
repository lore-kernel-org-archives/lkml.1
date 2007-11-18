Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbXKRVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbXKRVnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXKRVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:43:07 -0500
Received: from main.gmane.org ([80.91.229.2]:41347 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbXKRVnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:43:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Date: Sun, 18 Nov 2007 22:43:20 +0100
Message-ID: <fhqbkn$ttt$1@ger.gmane.org>
References: <200711182038.22055.deller@gmx.de> <20071118130503.7d5ec842.akpm@linux-foundation.org> <20071118213427.GB5696@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: mnhm-590daa25.pool.einsundeins.de
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:

> On Sun, Nov 18, 2007 at 01:05:03PM -0800, Andrew Morton wrote:
>> On Sun, 18 Nov 2007 20:38:21 +0100 Helge Deller <deller@gmx.de> wrote:
>> 
>> > Title: Add time-based RFC 4122 UUID generator
>> > 
>> > The current Linux kernel currently contains the generate_random_uuid()
>> > function, which creates - based on RFC 4122 - truly random UUIDs and
>> > provides them to userspace through /proc/sys/kernel/random/boot_id and
>> > /proc/sys/kernel/random/uuid.
>> > 
>> > This patch additionally adds the "Time-based UUID" variant of RFC 4122,
>> > with which userspace applications can easily get real unique time-based
>> > UUIDs through /proc/sys/kernel/random/uuid_time.
>> > A new /proc/sys/kernel/random/uuid_time_clockseq sysfs entry is
>> > available, so that the clock_seq value can be retained across system
>> > bootups (which is required by RFC 4122).
>> > 
>> > The attached implementation uses getnstimeofday() to get very
>> > fine-grained granularity. This helps, so that userspace tools can get a
>> > lot more UUIDs (if needed) per time than before.
>> > A mutex takes care of the proper locking against a mistaken double
>> > creation of UUIDs for simultanious running processes.
>> 
>> Who will use this feature, and for what?
>> 
>> (In fact, who uses the existing UUID generators, and for what?)
> 
> I use libuuid and I assume libuuid uses some uuid generator support
> from the kernel. 

No, it does not. It's pure userspace and may produce double UUIDs.

> libuuid comes from a package that Ted's maintain IIRC. 
> 
> I (my company) use uuid to uniquely identify objects in a distributed
> database.
> [Proprietary closed source stuff].

Same here.

Helge

