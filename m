Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYIXS3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYIXS3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYIXS3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:29:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYIXS3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:29:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080923053228.GA5825@wotan.suse.de>
References: <20080923053228.GA5825@wotan.suse.de> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org> <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz> <13787.1222095249@redhat.com> 
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, Hugh Dickins <hugh@veritas.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Date: Wed, 24 Sep 2008 19:18:25 +0100
Message-ID: <22749.1222280305@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> RFC Quick patch to fix nommu anonymous shared memory without breaking
> locking...

That works:

# /doshm sysv                                                                   
Command: sysv                                                                   
shmid: 0                                                                        
memory: 0xc3b00000                                                              
c3060000-c306a788 r-xs 00000000 00:0b 14582157   /lib/ld-uClibc-0.9.28.so       
c3100000-c315ede4 r-xs 00000000 00:0b 14582179   /lib/libuClibc-0.9.28.so       
c3938000-c393c000 rw-p 00000000 00:00 0                                         
c3a68000-c3a6c000 rw-p 00008000 00:0b 14582157   /lib/ld-uClibc-0.9.28.so       
c3a78000-c3a7c000 rw-p 00000000 00:0b 13763417   /doshm                         
c3a80000-c3aa0000 rwxp 00000000 00:00 0                                         
c3aa0000-c3aac000 rw-p 00000000 00:00 0                                         
c3ab8000-c3abc000 r-xs 00000000 00:0b 13763417   /doshm                         
c3b00000-c3bfa000 rw-S 00000000 00:07 0          /SYSV00000000 (deleted)        
c3b00000-c3bfa000 rw-S 00000000 00:07 0          /SYSV00000000 (deleted)        
nattch 2                                                                        


Acked-by: David Howells <dhowells@redhat.com>
