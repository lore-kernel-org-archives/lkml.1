Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbZJOVS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbZJOVS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935276AbZJOVSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:18:55 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:60895 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935256AbZJOVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:18:54 -0400
Message-ID: <4AD7916A.2080200@agilent.com>
Date: Thu, 15 Oct 2009 14:17:30 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Using remap_pfn_range() to increase total_vm beyond RLIMIT_AS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 21:17:49.0770 (UTC) FILETIME=[F2F3FAA0:01CA4DDC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remap_pfn_range() is defined in mm/memory.c and as far as I
can tell, does _not_ cause total_vm or reserved_vm to be updated.

Is this right?


RLIMIT_AS is only checked against total_vm in mm/mmap.c in the function
may_expand_vm().

I think this means that a device driver can map pages into
a process and thus effectively increase address space of
a process above and beyond the limit set by RLIMIT_AS.

Am I reading the code correctly?


Earl


