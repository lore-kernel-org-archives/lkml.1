Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbZEOJdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbZEOJdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbZEOJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:33:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50345 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbZEOJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:33:09 -0400
Date: Fri, 15 May 2009 11:38:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Josef Bacik <josef@redhat.com>,
       sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090515093838.GB16682@one.firstfloor.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871vqqkdf0.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ptr = mmap(0, page_size, ....);
> ...
> write(fd, ptr + page_size - 256, 512);
> 
> Write() will fail here, but it can write first 256 bytes. Previously,
> all 512 bytes were proceeded, but last 256 bytes were zeroed, and
> sys_write() returned 256. Not very nice too. 

Is that really something that users rely on? It looks like a seriously
broken user program. Which one is that? (just that I can avoid it :)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
