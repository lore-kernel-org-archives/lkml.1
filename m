Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZKEDaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZKEDaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 22:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZKEDaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 22:30:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZKEDaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:30:05 -0500
Message-ID: <4AF24681.1060504@redhat.com>
Date: Wed, 04 Nov 2009 22:29:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVj?= =?UTF-8?B?a2Vy?= 
	<fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/1] perf symbols: Use the buildids if present
References: <1257367843-26224-1-git-send-email-acme@infradead.org>
In-Reply-To: <1257367843-26224-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo<acme@redhat.com>
>
> Now 'perf record' will intercept PERF_RECORD_MMAP calls, creating a
> linked list of DSOs, then when the session finishes, it will traverse
> this list and read the buildids, stashing them at the end of the file
> and will set up a new feature bit in the header bitmask.
>
> 'perf report' will then notice this feature and populate the 'dsos' list
> and set the build ids.
>
> When reading the symtabs it will refuse to load from a file that doesn't
> have the same build id.
>
> Example:
>
>   [root@doppio ~]# perf report | head
>   /home/acme/bin/perf with build id b1ea544ac3746e7538972548a09aadecc5753868 not found, continuing without symbols
>    # Samples: 2621434559
>    #
>    # Overhead          Command                  Shared Object  Symbol
>    # ........  ...............  .............................  ......
>    #
>         7.91%             init  [kernel]        [k] read_hpet
>         7.64%             init  [kernel]        [k] mwait_idle_with_hints
>         7.60%          swapper  [kernel]        [k] read_hpet
>         7.60%          swapper  [kernel]        [k] mwait_idle_with_hints
>         3.65%             init  [kernel]        [k] 0xffffffffa02339d9
> [root@doppio ~]#
>
> In this case the 'perf' binary was an older one, vanished, so it the symbols
> probably wouldn't match.
>
> Next patches will support the kernel as well, reading the build id notes for it
> and the modules from /sys.

Great! then I can use it on 'perf probe' to check the dwarf binary is
same as running kernel.

> Another patch should also introduce a new plumbing command:
>
> 'perf list-buildids'
>
> that will then be used in porcelain that is distro specific to
> fetch -debuginfo packages where such buildids are present. This will in turn
> allow for one to run 'perf record' in one machine and 'perf report' in another.

Hmm, so, will this command list up all debuginfo files with buildids?
If so, can it also find a kernel binary built locally?

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

