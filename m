Return-Path: <linux-kernel-owner+w=401wt.eu-S1762013AbZD3MAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013AbZD3MAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZD3MAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:00:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:53357 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZD3L77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nxTeL9N3V1i6QHoy5+0I1VayOxxoF+YgVxSvWsfrvJD0A9ZsylHFNNmWCzXpXCmq5c
         AK3pxg33GnbE+Y7ikyJ6VUCcQQwobOuML1kSHZT4TbwQKNuZ26v1AxnUyNsdnTzogfUw
         cfmOPxOwh78v3dwEqmlQ2123apZEQ8tGEKaZM=
MIME-Version: 1.0
In-Reply-To: <20090429130430.4B11.A69D9226@jp.fujitsu.com>
References: <20090428090916.GC17038@localhost> <20090428120818.GH22104@mit.edu>
	 <20090429130430.4B11.A69D9226@jp.fujitsu.com>
Date: Thu, 30 Apr 2009 20:59:59 +0900
X-Google-Sender-Auth: 09fbf6d364284ecb
Message-ID: <2f11576a0904300459t61ae9619tcf8defacfc94f79@mail.gmail.com>
Subject: Re: Swappiness vs. mmap() and interactive response
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Theodore Tso <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> test environment: no lvm, copy ext3 to ext3 (not mv), no change swappiness,
>                  CFQ is used, userland is Fedora10, mmotm(2.6.30-rc1 + mm patch),
>                  CPU opteronx4, mem 4G
>
> mouse move lag:               not happend
> window move lag:              not happend
> Mapped page decrease rapidly: not happend (I guess, these page stay in
>                                          active list on my system)
> page fault large latency:     happend (latencytop display >1200ms)
>
>
> Then, I don't doubt vm replacement logic now.
> but I need more investigate.
> I plan to try following thing today and tommorow.
>
>  - XFS
>  - LVM
>  - another io scheduler (thanks Ted, good view point)
>  - Rik's new patch

hm, AS io-scheduler don't make such large latency on my environment.
Elladan, Can you try to AS scheduler? (adding boot option "elevator=as")
