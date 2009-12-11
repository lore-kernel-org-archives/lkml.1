Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbZLKBHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbZLKBHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZLKBHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:07:21 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45764 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZLKBHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TRrtYlFiZHefaQ2BYv5Ip3Bxm21IQUPJS+U6ao/eAAXbYz0douQcFd+ArKfj1MOR2p
         W7K/Sn+uTti9aTak6hFT0JUFylJrv06RRrRieh4NkX1iKWn2SdG25Ak+ish5nU2/ldIY
         YT0BF5VvAnzpesqdrx6jn+yktYjQGNZnGJNfM=
MIME-Version: 1.0
In-Reply-To: <20091210165911.97850977.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091210165911.97850977.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Dec 2009 10:07:26 +0900
Message-ID: <28c262360912101707i314972d7nf540b27595b8883d@mail.gmail.com>
Subject: Re: [RFC mm][PATCH 3/5] counting swap ents per mm
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 4:59 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> One of frequent questions from users about memory management is
> what numbers of swap ents are user for processes. And this information will
> give some hints to oom-killer.
>
> Besides we can count the number of swapents per a process by scanning
> /proc/<pid>/smaps, this is very slow and not good for usual process information
> handler which works like 'ps' or 'top'.
> (ps or top is now enough slow..)
>
> This patch adds a counter of swapents to mm_counter and update is at
> each swap events. Information is exported via /proc/<pid>/status file as
>
> [kamezawa@bluextal ~]$ cat /proc/self/status
> Name:   cat
> State:  R (running)
> Tgid:   2904
> Pid:    2904
> PPid:   2862
> TracerPid:      0
> Uid:    500     500     500     500
> Gid:    500     500     500     500
> FDSize: 256
> Groups: 500
> VmPeak:    82696 kB
> VmSize:    82696 kB
> VmLck:         0 kB
> VmHWM:       504 kB
> VmRSS:       504 kB
> VmData:      172 kB
> VmStk:        84 kB
> VmExe:        48 kB
> VmLib:      1568 kB
> VmPTE:        40 kB
> VmSwap:        0 kB <============== this.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
