Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbXEDDVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbXEDDVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXEDDVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:21:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbXEDDVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:21:14 -0400
Date: Thu, 3 May 2007 20:21:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
Message-Id: <20070503202111.667c9b14.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 20:08:41 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> Performance tests show a slight improvements in netperf (not a
> strong case for a performance improvement but removing the
> constructor has definitely no negative impact so why keep
> this around?).
> 
> TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost (127.0.0.1) port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> Before:
>  87380  16384  16384    10.01    6026.04
>  87380  16384  16384    10.01    5992.17
>  87380  16384  16384    10.01    6071.23
> 
> After:
>  87380  16384  16384    10.01    6090.20
>  87380  16384  16384    10.01    6078.3
>  87380  16384  16384    10.00    6013.52

How could a filesystem change affect networking performance?

The change looks nice, but I'd microbenchmark it with a write-to-ext2-on-ramdisk
or something like that.
