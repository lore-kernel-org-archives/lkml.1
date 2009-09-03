Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZICNyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZICNyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZICNyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:54:41 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52527 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZICNyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:54:40 -0400
Message-ID: <4A9FCA9D.8010702@interlog.com>
Date: Thu, 03 Sep 2009 09:54:37 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>
CC: linux-scsi@vger.kernel.org, Bob Tracy <rct@gherkin.frus.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] sg: fix oops in the error path in sg_build_indirect()
References: <20090903033945.GA20755@gherkin.frus.com> <20090903142708.0b820ca1@leela>
In-Reply-To: <20090903142708.0b820ca1@leela>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt wrote:
> When the allocation fails in sg_build_indirect(), an oops happens in
> the error path. It's caused by an obvious typo.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Reported-by: Bob Tracy <rct@gherkin.frus.com>
> ---
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 9230402..4968c4c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1811,7 +1811,7 @@ retry:
>  	return 0;
>  out:
>  	for (i = 0; i < k; i++)
> -		__free_pages(schp->pages[k], order);
> +		__free_pages(schp->pages[i], order);
>  
>  	if (--order >= 0)
>  		goto retry;
> --

Ouch.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
