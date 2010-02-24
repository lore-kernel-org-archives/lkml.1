Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0BXC0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:26:11 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:57840 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0BXC0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:26:09 -0500
From: James Cloos <cloos@jhcloos.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap problem?)
In-Reply-To: <20100223224111.GC16175@discord.disaster> (Dave Chinner's message
	of "Wed, 24 Feb 2010 09:41:11 +1100")
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se>
	<alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se>
	<20100223044818.GD22370@discord.disaster>
	<alpine.DEB.1.10.1002230820110.12694@uplift.swm.pp.se>
	<20100223133219.GB16175@discord.disaster>
	<alpine.DEB.1.10.1002232138021.12694@uplift.swm.pp.se>
	<20100223224111.GC16175@discord.disaster>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Tue, 23 Feb 2010 21:25:30 -0500
Message-ID: <m37hq3id3h.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M> You're right, it doesn't say that anymore in 2.6.31, so I think I'm 
M> indeed running with barriers on.

When barriers were added to ext4, I saw a similar slowdown on lock- and
sync- heavy workloads.

Based on a recent thread on the ext4 list I've started using deadline
rather than cfq on that disk.  There are some slowdowns on that disk's
other partition, but the overall throughput is significantly better than
using the combination of cfq, ext4 and barriers.

You might want to test out deadline and/or noop.

Cf:  /sys/block/*/queue/scheduler

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
