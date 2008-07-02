Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYGBLNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYGBLNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYGBLNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:13:47 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:6270 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYGBLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:13:46 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
From: Andi Kleen <andi@firstfloor.org>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
	<20080702003755.4daff613.akpm@linux-foundation.org>
Date: Wed, 02 Jul 2008 13:12:46 +0200
In-Reply-To: <20080702003755.4daff613.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 2 Jul 2008 00:37:55 -0700")
Message-ID: <87r6acsfo1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jul 2008 11:05:24.0721 (UTC) FILETIME=[870BF610:01C8DC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> sysfs is part of the kernel ABI.  We should design our interfaces there
> as carefully as we design any others.

The basic problem is that sysfs exports an internal kernel object model
and these tend to change. To really make it stable would require 
splitting it into internal and presented interface.  I would be all
for it, but it doesn't seem realistic to me currently. If we cannot
even get basic interfaces like the syscall capability stable how would
you expect to stabilize the complete kobjects? 

And the specific problem with the x86 cache sysfs interface is that it's so
complicated that no human can really read it directly. This means to
actually use it you need some kind of frontend (i have a cheesy
lscache script for this). I expect that eventually we'll have a standard
tool for this. Right now most people still rely on /proc/cpuinfo
output (which is actually human readable!), but it only shows simple
cache topologies (L2 only) and with L3 and more complicated ones
being more wide spread that doesn't cut it anymore. So I expect
eventually utils-linux will grow a standard lscache program for this.
And I expect people will eventually just use the output frontend instead of 
sysfs.

-Andi
