Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYAURZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYAURZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYAURY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:24:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYAURY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:24:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=X1QBJwB1pMvmU0sWVRTr8YH2Gz84XQpt3qXKq45kNMR36xpb7RkyeJyxYoFXNX1Gs6lS9nUQreAg5b9/O1hsUtFm8Tz0J8nEcKvsuWhPOUazqjVuGPr9d3flkteltmtkgo+jIV3cCLJUemLfIq+VOM31p60eZcjni71IKy4aarg=
Date: Mon, 21 Jan 2008 20:24:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
Message-ID: <20080121172437.GA6722@cvg>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202140.57829.yinghai.lu@sun.com> <200801210658.04030.ak@suse.de> <200801202257.47195.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801202257.47195.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sun, Jan 20, 2008 at 10:57:46PM -0800]
| [PATCH] x86_64: check if Tom2 is enabled
| 
| need to applied after andi's amd special tom2 wb check patch
| 
| in amd_special_default_mtrr need to check if TOM2 is enabled
| 
| Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
| 
| diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
| index 289ba1a..26eed57 100644
| --- a/arch/x86/kernel/cpu/mtrr/main.c
| +++ b/arch/x86/kernel/cpu/mtrr/main.c
| @@ -641,6 +641,7 @@ early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
|   * Note this won't check if the MTRRs < 4GB where the magic bit doesn't
|   * apply to are wrong, but so far we don't know of any such case in the wild.
|   */
| +#define Tom2Enabled (1U << 21)
|  #define Tom2ForceMemTypeWB (1U << 22)
|  
|  static __init int amd_special_default_mtrr(void)
| @@ -661,7 +662,8 @@ static __init int amd_special_default_mtrr(void)
|  	 * Memory between 4GB and top of mem is forced WB by this magic bit.
|  	 * Reserved before K8RevF, but should be zero there.
|  	 */
| -	if (l & Tom2ForceMemTypeWB)
| +	if ((l & (Tom2Enabled | Tom2ForceMemTypeWB)) ==
| +		 (Tom2Enabled | Tom2ForceMemTypeWB))
|  		return 1;
|  	return 0;
|  }

is it possible to change 'l' and 'h' to 'low' and 'high'?
'cause 'l' does look like '1' (one) number...

		- Cyrill -
