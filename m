Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZGTSA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZGTSA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZGTSA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:00:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZGTSA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:00:26 -0400
Date: Mon, 20 Jul 2009 13:56:44 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 01/14] amd64_edac: simplify error type bits extractors
Message-ID: <20090720175644.GK8168@redhat.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com> <1248106385-27514-2-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248106385-27514-2-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,
> -	/* If this was an 'observed' error, early out */
> -	if (ec_pp == K8_NBSL_PP_OBS)
> -		return;		/* We aren't the node involved */
> +
> +	/* Bail early out if this was an 'observed' error */
> +	if (((ec >> 9) & 0x3) == K8_NBSL_PP_OBS)
> +		return;
minor thing:
this patch and others makes me think if it wouldn't be better to have:
	#define PP(x)		(((x) >> 9) & 0x3)
	#define PP_MSG(x)	pp_msgs[PP(x)]
and the same for LL, TT, RRRR.

the rest of the patch series looks good to me

-- 
Aristeu

