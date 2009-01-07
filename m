Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbZAGRiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbZAGRiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZAGRiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:38:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59490 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZAGRiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:38:06 -0500
Message-ID: <4964E7EE.7090301@redhat.com>
Date: Wed, 07 Jan 2009 12:35:42 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Eric Hopper <hopper@omnifarious.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: nosync, an idea for general filesystem mount flag
References: <20090106184205.GC15454@omnifarious.org>
In-Reply-To: <20090106184205.GC15454@omnifarious.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Hopper wrote:
> Maybe somebody has thought of this before.  But I think it would be
> useful to have a mount flag telling the filesystem layer that a certain
> filesystem never ever needs to be synced, even when the 'sync' system
> call is called.
> 
> My /tmp, for example, is reformatted on each and every boot.  There is
> no reason for anything written to /tmp to ever hit the disk.  The only
> reason is to make room for something else in memory.
> 
> I think this could potentially help out notebooks that only had solid
> state drives.
> 
> Anyway, just a random thought,

This is why tmpfs was written, but if you're using an SSD with large erase 
blocks, and want to avoid setting up a swap partition, you could put the 
filesystem on a loop device instead.  The sync calls would be absorbed as writes 
to the non-sync backing file.  It's slightly more complicated to set up, and 
slightly less flexible, but the next generation SSDs won't have problems with 
random write performance, so the convenience of implementing such an option 
would be rather short-lived.  It's not a fundamentally evil idea, but it just 
doesn't seem to be worth the effort, particularly to maintain it for the rest of 
eternity.

-- Chris
