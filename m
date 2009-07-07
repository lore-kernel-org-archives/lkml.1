Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZGGQuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZGGQuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZGGQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:50:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59083 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755100AbZGGQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:50:07 -0400
Date: Tue, 7 Jul 2009 12:49:56 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
In-Reply-To: <20090707101855.0C63.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907071248560.5124@gentwo.org>
References: <20090707090120.1e71a060.minchan.kim@barrios-desktop> <20090707090509.0C60.A69D9226@jp.fujitsu.com> <20090707101855.0C63.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, KOSAKI Motohiro wrote:

> +++ b/include/linux/mmzone.h
> @@ -100,6 +100,8 @@ enum zone_stat_item {
>  	NR_BOUNCE,
>  	NR_VMSCAN_WRITE,
>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
> +	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
> +	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */

LRU counters are rarer in use then the counters used for dirty pages etc.

Could you move the counters for reclaim into a separate cacheline?

