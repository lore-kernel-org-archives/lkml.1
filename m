Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZKEOlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZKEOlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZKEOlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:41:46 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:36583 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbZKEOlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hka4mCaIVj/fpUTXSCBTq1/wB36bw6eR/6dOi0JvwiDr22xltDeqnP4NbEyHGzisH/
         J7aLqftU+bH+J1kfPz4+MufbuUvfvWGTP53bzrTo+xhq5FUYXI6Om4t7zgii4jCG7W3L
         V3UHUmldnssTh4Tvxyww+rtAFlJoUnFMcRfbw=
MIME-Version: 1.0
In-Reply-To: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 5 Nov 2009 23:41:50 +0900
X-Google-Sender-Auth: 347d5291c914c71d
Message-ID: <2f11576a0911050641j8799c5kbd390116edcc566d@mail.gmail.com>
Subject: Re: [PATCH] show per-process swap usage via procfs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       cl@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/4 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>
> Passed several tests and one bug was fixed since RFC version.
> This patch is against mmotm.
> =
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> RSS usage is important information but one more information which
> is often asked by users is "usage of swap".(user support team said.)
>
> This patch counts swap entry usage per process and show it via
> /proc/<pid>/status. I think status file is robust against new entry.
> Then, it is the first candidate..
>
>  After this, /proc/<pid>/status includes following line
>  <snip>
>  VmPeak:   315360 kB
>  VmSize:   315360 kB
>  VmLck:         0 kB
>  VmHWM:    180452 kB
>  VmRSS:    180452 kB
>  VmData:   311624 kB
>  VmStk:        84 kB
>  VmExe:         4 kB
>  VmLib:      1568 kB
>  VmPTE:       640 kB
>  VmSwap:   131240 kB <=== new information
>
> Note:
>  Because this patch catches swap_pte on page table, this will
>  not catch shmem's swapout. It's already accounted in per-shmem
>  inode and we don't need to do more.

Sidenote: top(1) can show SWAP usage. but it is crazy buggy
implementation. it define
VIRT = SWAP + RES (see man top or actual source code). this patch help
to fix its insane
calculation.

    Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
