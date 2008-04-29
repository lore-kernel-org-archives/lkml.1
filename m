Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYD2OLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYD2OLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYD2OLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:11:12 -0400
Received: from host64.cybernetics.com ([70.169.137.4]:4036 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYD2OLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:11:10 -0400
Message-ID: <48172C72.1000501@cybernetics.com>
Date: Tue, 29 Apr 2008 10:10:58 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.24 regression: deadlock on coredump of big process
References: <4815E932.1040903@cybernetics.com> <20080429100048.3e78b1ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080429100048.3e78b1ba.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 28 Apr 2008 11:11:46 -0400
> Tony Battersby <tonyb@cybernetics.com> wrote:
>
>   
>> Below is the program that triggers the deadlock; compile with
>> -D_REENTRANT -lpthread.
>>
>>     
> What happens if you changes size of stack (of pthreads) smaller ?
> (maybe ulimit -s will work also for threads.)
>
> Thanks,
> -Kame
>
>
>   

If I leave more memory free by changing the argument to
malloc_all_but_x_mb(), then I have to increase the number of threads
required to trigger the deadlock.  Changing the thread stack size via
setrlimit(RLIMIT_STACK) also changes the number of threads that are
required to trigger the deadlock.  For example, with
malloc_all_but_x_mb(16) and the default stack size of 8 MB, <= 5 threads
will coredump successfully, and >= 6 threads will deadlock.  With
malloc_all_but_x_mb(16) and a reduced stack size of 4096 bytes, <= 8
threads will coredump successfully, and >= 9 threads will deadlock.

Also note that the "free" command reports 10 MB free memory while the
program is running before the segfault is triggered.

Tony

