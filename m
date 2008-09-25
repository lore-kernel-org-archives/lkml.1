Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYIYUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYIYUFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYIYUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:05:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:39904 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYIYUFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:05:42 -0400
X-BigFish: VPS-35(zz1432R98dR936eQ62a3L1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7RP4W-02-AYN-01
Date: Thu, 25 Sep 2008 22:05:21 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] oprofile: Don't report Nehalem as core_2
Message-ID: <20080925200521.GJ23557@erda.amd.com>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org> <1219250433-25516-2-git-send-email-andi@firstfloor.org> <1219250433-25516-3-git-send-email-andi@firstfloor.org> <1219250433-25516-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1219250433-25516-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Sep 2008 20:05:26.0307 (UTC) FILETIME=[0D025F30:01C91F4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.08 18:40:32, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This essentially reverts Linus' earlier 4b9f12a3779c548b68bc9af7d94030868ad3aa1b
> commit. Nehalem is not core_2, so it shouldn't be reported as such.
> However with the earlier arch perfmon patch it will fall back to
> arch perfmon mode now, so there is no need to fake it as core_2.
> The only drawback is that Linus will need to patch the arch perfmon
> support into his oprofile binary now, but I think he can do that.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I will send this patch upstream together with the architectural
perfmon implementation and when the userland part is upstream.

-Robert

> ---
>  arch/x86/oprofile/nmi_int.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 6438c32..669a713 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -418,9 +418,6 @@ static int __init ppro_init(char **cpu_type)
>  	case 15: case 23:
>  		*cpu_type = "i386/core_2";
>  		break;
> -	case 26:
> -		*cpu_type = "i386/core_2";
> -		break;
>  	default:
>  		/* Unknown */
>  		return 0;
> -- 
> 1.5.6
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

