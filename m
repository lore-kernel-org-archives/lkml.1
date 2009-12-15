Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZLOXnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZLOXnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZLOXnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:43:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZLOXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:43:11 -0500
Message-ID: <4B281E83.5050900@zytor.com>
Date: Tue, 15 Dec 2009 15:40:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org
Subject: Re: [PATCH] x86, mce: rework output of MCE banks ownership information
References: <4B26EBB0.3090507@jp.fujitsu.com> <4B281C05.7050404@sgi.com>
In-Reply-To: <4B281C05.7050404@sgi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me, Hidetoshi, ACK?

	-hpa

On 12/15/2009 03:30 PM, Mike Travis wrote:
> Subject: [PATCH] x86, mce: rework output of MCE banks ownership information
> From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> 
> The output of MCE banks ownership information on boot tend
> to be long on new processor which has many banks:
> 
>   CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
> 
> This message can fill up the console output when the number
> of cpus is large.
> 
> This patch suppress this info message on boot, and introduce
> debug message in shorter format instead, like:
> 
>   CPU 1 MCE banks map: ssCC PCss ssPP ssss ssss ss
> 
>   where: s: shared, C: checked by cmci, P: checked by poll.
> 
> This patch still keep the info when ownership is updated.
> E.g. when a cpu take over the ownership from hot-removed cpu,
> both message will be shown:
> 
>   CPU 1 MCE banks map updated: CMCI:6 CMCI:7 CMCI:10 CMCI:11
>   CPU 1 MCE banks map: ssCC PCCC ssPP ssCC ssss ss
> 
> v2:
>   - stop changing the level of message on update
>   - change the number of banks message on boot to debug level
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> v3: (again)
>   - avoid use of pr_cont with pr_debug in print_banks_map()
> 
> Signed-off-by: Mike Travis <travis@sgi.com>

