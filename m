Return-Path: <linux-kernel-owner+w=401wt.eu-S933067Ab0AFXVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab0AFXVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789Ab0AFXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:21:09 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:40120 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab0AFXVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:21:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I5cBGkqNJQ03Yh+/0iFzAf0Nd93ZiNgGswKvrwwXrmxoEFLPem8mEnt9a+skYVsGHM
         KoQvHbfSIW3gv+h3lBe/VR2D1BKdP6okCMixfmOu1ymXjKndwTq29gGsmaR4Bud/9xec
         uyba8Qp+356fBIFz8JdpgBG9xo7Zs3CGcnyMo=
MIME-Version: 1.0
In-Reply-To: <1262795169-9095-3-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
	 <1262795169-9095-3-git-send-email-mel@csn.ul.ie>
Date: Wed, 6 Jan 2010 15:21:01 -0800
X-Google-Sender-Auth: 75e30120ad2abe44
Message-ID: <eada2a071001061521t53dff44bkaf54dab058b1d01b@mail.gmail.com>
Subject: Re: [PATCH 2/7] Export unusable free space index via 
	/proc/pagetypeinfo
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 8:26 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 6051fba..e1ea2d5 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -451,6 +451,104 @@ static int frag_show(struct seq_file *m, void *arg)
>        return 0;
>  }
>
> +
> +struct config_page_info {
> +       unsigned long free_pages;
> +       unsigned long free_blocks_total;
> +       unsigned long free_blocks_suitable;
> +};
> +
> +/*
> + * Calculate the number of free pages in a zone, how many contiguous
> + * pages are free and how many are large enough to satisfy an allocation of
> + * the target size. Note that this function makes to attempt to estimate

s/makes to/makes no/    ?



Tim
