Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbZD2SSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbZD2SSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759436AbZD2SSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:18:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbZD2SSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:18:14 -0400
Date: Wed, 29 Apr 2009 20:17:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using
	sysfs
Message-ID: <20090429181754.GA8321@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-21-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241024107-14535-21-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |  287 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 287 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index b1a7e8c..4d1076f 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -4621,3 +4621,290 @@ static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
>  
>  #endif	/* DEBUG */
>  
> +#ifdef CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION

this should be in a separate .c file under drivers/edac/amd64/. 

Introducing large #ifdef sections like that is not very clean. The 
amd64_edac.c file is _way_ too large at more than 5000 lines of 
code.

	Ingo
