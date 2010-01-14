Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612Ab0ANA4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0ANA4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642Ab0ANA4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:56:16 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:55930 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0ANA4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=APHHY4+JeN49zPat15ZJywQmllg/rE+lH9r9eht5zFIOqpgjCIyPNnyNjLZb/QSFCu
         w2W9NE4rW23F6acArVO/865OXUNcerofacEJdYpMxhXkRt9hNrEJmM/WQEZlYmnBi+Oe
         rHMCqKQrufcCBftwTuyxNpUaNecLa3PSplhNQ=
Message-ID: <4B4E6BAC.6030907@gmail.com>
Date: Wed, 13 Jan 2010 18:56:12 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: greg@enjellic.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Memory leak makes 'Blast the Bubbles' problematic.
References: <201001131548.o0DFmtrD004610@wind.enjellic.com>
In-Reply-To: <201001131548.o0DFmtrD004610@wind.enjellic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 09:48 AM, greg@enjellic.com wrote:
> Hi, hope the week is going well for everyone.
>
> Unless I miss my guess there is some type of leak or other memory
> anomaly starting in at least late model 2.6.31.x kernels.  I took a
> snapshot of the behavior on 2.6.32.3 as well since I knew that
> 2.6.31.11 would be considered long in the tooth by all the informed
> intelligentia who would be looking at this...... :-)
>
> The machine in question is an older Dell desktop machine with a 1.7Ghz
> Pentium 4 and 756 megabytes of RAM.  My wife uses it to run X and play
> her Flash games in Firefox.  She started chewing on my rear end about
> a month ago complaining that her games were running so slow she
> couldn't stand it.  Rebooting the machine would restore proper
> behavior for a short period of time.  She logs in and out of X from
> text mode so the issue isn't with X and/or Firefox chewing up all the
> memory.
>
> I booted up a fresh copy of 2.6.32.3 yesterday morning and dropped all
> the caches (/proc/sys/vm/drop_caches).  I told my wife to play some
> games last night so I could instrument the change.  This morning I
> dropped all the caches and took another snapshot of memory status and
> the impact of whatever is happening seems clear, ie:
>
>
> Before:
>               total       used       free     shared    buffers     cached
> Mem:        774644     308284     466360          0      19116     270120
> -/+ buffers/cache:      19048     755596
> Swap:       125368          0     125368
>
> After:
>               total       used       free     shared    buffers     cached
> Mem:        774644     645648     128996          0     155772     294664
> -/+ buffers/cache:     195212     579432
> Swap:       125368          0     125368
>
>
> I did a little bit more investigating and I'm suspicious the behavior
> is secondary to updatedb running rather anything secondary to X having
> been run.
>
> The 'Before' snapshot was taken from logs the system mails me every
> night at midnight.  That would have been after my wife spent a few
> hours playing her Flash games but before updatedb ran.
>
> The kernel is custom compiled for the machine.  I'm including the
> .config below along with diffs showing before/after memory consumption
> status.  I also included a 'ps fax' listing of what was running at the
> time I took the snapshots.  I'd be happy to grab any additional
> instrumentation people feel they might need.
>
> I hope all this is helpful since whatever behavior is being tickled
> makes recent kernels problematic on this caliber of hardware.  Let
> alone the effects on my rear end from my beloved not being able to
> play 'Blast the Bubbles' the way she would like.
>
> Let me know if I can provide any additional information.
>
> Best wishes for a pleasant afternoon to everyone.
>
> Greg
>
>
> /proc/meminfo diff: -------------------------------------------------------
> --- meminfo.txt Tue Jan 12 11:31:48 2010
> +++ -   Wed Jan 13 09:25:11 2010
> @@ -1,35 +1,35 @@
>   MemTotal:         774644 kB
> -MemFree:          719848 kB
> -Buffers:            3124 kB
> -Cached:            39832 kB
> +MemFree:          128800 kB
> +Buffers:          155784 kB
> +Cached:           294768 kB
>   SwapCached:            0 kB
> -Active:            15968 kB
> -Inactive:          30900 kB
> -Active(anon):       3912 kB
> +Active:           173152 kB
> +Inactive:         281488 kB
> +Active(anon):       4088 kB
>   Inactive(anon):        0 kB
> -Active(file):      12056 kB
> -Inactive(file):    30900 kB
> +Active(file):     169064 kB
> +Inactive(file):   281488 kB
>   Unevictable:           0 kB
>   Mlocked:               0 kB
>   SwapTotal:        125368 kB
>   SwapFree:         125368 kB
> -Dirty:                12 kB
> +Dirty:                 4 kB
>   Writeback:             0 kB
> -AnonPages:          3928 kB
> -Mapped:             4172 kB
> +AnonPages:          4108 kB
> +Mapped:             4260 kB
>   Shmem:                 0 kB
> -Slab:               4312 kB
> -SReclaimable:       1244 kB
> -SUnreclaim:         3068 kB
> -KernelStack:         536 kB
> -PageTables:          400 kB
> +Slab:             187472 kB
> +SReclaimable:     184256 kB
> +SUnreclaim:         3216 kB
> +KernelStack:         592 kB
> +PageTables:          444 kB
>   NFS_Unstable:          0 kB
>   Bounce:                0 kB
>   WritebackTmp:          0 kB
>   CommitLimit:      512688 kB
> -Committed_AS:       9804 kB
> +Committed_AS:      11676 kB
>   VmallocTotal:     254124 kB
>   VmallocUsed:         212 kB
>   VmallocChunk:     247300 kB
> -DirectMap4k:        5596 kB
> -DirectMap2M:      780288 kB
> +DirectMap4k:       40412 kB
> +DirectMap2M:      745472 kB

It looks like the system accumulated some more dcache entries, but those 
should presumably get freed up if the system needs the memory. The 
output of "vmstat 1" while the slowness is occurring might be more 
interesting..
