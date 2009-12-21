Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZLUGh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZLUGh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 01:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbZLUGh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 01:37:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZLUGh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 01:37:28 -0500
Message-ID: <4B2F1630.7090406@zytor.com>
Date: Sun, 20 Dec 2009 22:31:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: different symbol address between System.map and /proc/kallsyms
References: <4B2ECD47.7040202@cn.fujitsu.com>
In-Reply-To: <4B2ECD47.7040202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2009 05:20 PM, Xiao Guangrong wrote:
> Hi,
> 
> The symbol address in System.map and /proc/kallsys is different:
> 
> # cat System.map | grep _text
>   c1000000 T _text
> # cat /proc/kallsyms | grep _text
>   c0100000 T _text
> 
> # readelf -s vmlinux | grep _text
> 35078: c1000000     0 NOTYPE  GLOBAL DEFAULT    1 _text
> 
> So, perf can't get sysmbol address properly:
> 
> # ./perf report
> # Samples: 29
> #
> # Overhead  Command        Shared Object  Symbol
> # ........  .......  ...................  ......
> #
>     93.10%    sleep             c014f988  [k] 0x000000c014f988
>      3.45%    sleep  libc-2.9.90.so       [.] _int_malloc
>      3.45%    sleep  [kernel]             [k] 0x000000c014f988

That is normal if you have a relocatable kernel which has been loaded at
the non-compile-time default address.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

