Return-Path: <linux-kernel-owner+w=401wt.eu-S933870AbXCNH3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbXCNH3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 03:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbXCNH3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 03:29:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:29590 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933870AbXCNH3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 03:29:05 -0400
Message-ID: <45F7A4B3.5040005@sw.ru>
Date: Wed, 14 Mar 2007 10:30:59 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] kernel/pid.c pid allocation wierdness
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm looking at how alloc_pid() works and can't understand
one (simple/stupid) thing.

It first kmem_cache_alloc()-s a strct pid, then calls
alloc_pidmap() and at the end it taks a global pidmap_lock()
to add new pid to hash.

The question is - why does alloc_pidmap() use at least
two atomic ops and potentially loop to find a zero bit
in pidmap? Why not call alloc_pidmap() under pidmap_lock
and find zero pid in pidmap w/o any loops and atomics?

The same is for free_pid(). Do I miss something?

Thank,
Pavel
