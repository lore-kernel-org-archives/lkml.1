Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYHSHys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYHSHys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYHSHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:54:30 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:65322 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbYHSHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:54:29 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5U8MJ-04-G45-01
Date: Tue, 19 Aug 2008 09:54:17 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Leo Duran <leo.duran@amd.com>
Subject: Re: [PATCH] x86 iommu: remove unneeded parenthesis
Message-ID: <20080819075417.GA12255@amd.com>
References: <alpine.LNX.1.10.0808190211060.18058@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808190211060.18058@jikos.suse.cz>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Aug 2008 07:54:18.0124 (UTC) FILETIME=[C8401CC0:01C901D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 02:13:55AM +0200, Jiri Kosina wrote:
> The parenthesis in __iommu_queue_command() are not needed when assigning into 'target' variable.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index de39e1f..69b4d06 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -65,7 +65,7 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
>  	u8 *target;
> 
>  	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
> -	target = (iommu->cmd_buf + tail);
> +	target = iommu->cmd_buf + tail;
>  	memcpy_toio(target, cmd, sizeof(*cmd));
>  	tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
>  	head = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
> 

True, thanks Jiri.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

