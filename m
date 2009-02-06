Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZBFAXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZBFAXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZBFAX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:23:27 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45529 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZBFAX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:23:27 -0500
Message-Id: <6.0.0.20.2.20090206091511.0764d0a8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Fri, 06 Feb 2009 09:20:30 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] lseek: remove i_mutex
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090205120519.a62e8c4f.akpm@linux-foundation.org>
References: <6.0.0.20.2.20090203165430.06ae1cd8@172.19.0.2>
 <20090205120519.a62e8c4f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 05:05 09/02/06, Andrew Morton wrote:
>On Tue, 03 Feb 2009 17:04:40 +0900
>Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
>
>> I removed i_mutex from generic_file_llseek.
>> I think that the reason of protecting lseek with i_mutex is just
>> touching i_size atomically.
>> 
>> So I introduce i_size_read here so i_mutex is no longer needed.
>> 
>> Following patch removes i_mutex from generic_file_llseek, and deletes 
>> generic_file_llseek_nolock totally.
>> 
>> Currently there is i_mutex contention not only around lseek, but also 
>fsync or write.
>> So,  I think we can mitigate i_mutex contention between fsync lseek and 
>write by
>> removing i_mutex.
>
>Prior to this change, generic_file_llseek() modified file->f_pos
>atomically with respect to other i_mutex holders.
>
>After this change, it doesn't.

Hi Andrew.

Even before this change is applied, file->f_pos access is not atomic.
sys_read change f_pos value through file_pos_write without i_mutex.
I think seqlock is needed to make f_pos access atomic.

