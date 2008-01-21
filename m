Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYAUF6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYAUF6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 00:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYAUF6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 00:58:09 -0500
Received: from ns1.suse.de ([195.135.220.2]:56857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYAUF6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 00:58:08 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn v2
Date: Mon, 21 Jan 2008 06:58:03 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801192045.17291.yinghai.lu@sun.com> <200801201608.15401.ak@suse.de> <200801202140.57829.yinghai.lu@sun.com>
In-Reply-To: <200801202140.57829.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210658.04030.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  {
>  	u32 l, h;
>  
> @@ -661,8 +661,9 @@ static __init int amd_special_default_mt
>  	 * Memory between 4GB and top of mem is forced WB by this magic bit.
>  	 * Reserved before K8RevF, but should be zero there.
>  	 */
> -	if (l & Tom2ForceMemTypeWB)
> -		return 1;
> +	if (l & Tom2Enabled)
> +		if (l & Tom2ForceMemTypeWB)
> +			return 1;

That change is good agreed, but I would suggest to put it into a separate
patch with a description

-Andi
