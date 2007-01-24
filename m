Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbXAXVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbXAXVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbXAXVy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:54:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:43889 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbXAXVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:54:28 -0500
Subject: Re: [PATCH] gpu/radeonfb: add GPU support to radeonfb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roger While <simrw@sim-basis.de>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie
In-Reply-To: <6.1.1.1.2.20070124172600.04f40dc8@192.168.6.12>
References: <6.1.1.1.2.20070124172600.04f40dc8@192.168.6.12>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 08:54:08 +1100
Message-Id: <1169675648.18754.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 17:30 +0100, Roger While wrote:
> @@ -241,9 +241,9 @@ void radeonfb_engine_reset(struct radeon
>   	INREG(HOST_PATH_CNTL);
>   	OUTREG(HOST_PATH_CNTL, host_path_cntl);
> 
> -	if (rinfo->family != CHIP_FAMILY_R300 ||
> -	    rinfo->family != CHIP_FAMILY_R350 ||
> -	    rinfo->family != CHIP_FAMILY_RV350)
> +	if (rinfo->gpu_info->family != CHIP_FAMILY_R300 ||
> +	    rinfo->gpu_info->family != CHIP_FAMILY_R350 ||
> +	    rinfo->gpu_info->family != CHIP_FAMILY_RV350)
>   		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
> 
> Alarm bells going off - "!=" combined with "||" ?
> Looks like a reset will always be done.

Wow, good catch ! That's a bug that has been in radeonfb pretty much for
ever ! Might have come from earlier versions of X before we had
IS_R300_VARIANT...

B

