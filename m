Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbZD2STu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbZD2STu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZD2STk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:19:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48075 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846AbZD2STj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:19:39 -0400
Date: Wed, 29 Apr 2009 20:19:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] amd64_edac: add error decoding logic
Message-ID: <20090429181913.GC8321@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-17-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241024107-14535-17-git-send-email-borislav.petkov@amd.com>
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
>  drivers/edac/amd64_edac.c |  569 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 569 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 88849a4..fee9ec4 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -3260,3 +3260,572 @@ static int get_channel_from_ecc_syndrome(unsigned short syndrome)
>  	debugf0("%s(): syndrome(%x) not found\n", __func__, syndrome);
>  	return -1;
>  }
> +
> +/*
> + * toString tables for the various error decoding values
> + */
> +static const char *tt_msgs[] = {        /* transaction type */
> +	"instruction",
> +	"data",
> +	"generic",
> +	"reserved"
> +};

this too should be in a separate file.

	Ingo
