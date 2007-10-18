Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXJRTOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXJRTOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbXJRTOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:14:34 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43762 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbXJRTOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:14:34 -0400
Message-ID: <4717B072.6090506@bull.net>
Date: Thu, 18 Oct 2007 21:13:54 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Fix guest time accounting going faster than user time accounting
References: <200710181941.31181.borntraeger@de.ibm.com>
In-Reply-To: <200710181941.31181.borntraeger@de.ibm.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/10/2007 21:21:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/10/2007 21:21:03,
	Serialize complete at 18/10/2007 21:21:03
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Laurent Vivier <Laurent.Vivier@bull.net>

Christian Borntraeger a écrit :
> Seems I overlooked this type while reviewing Laurents patch.
> cputime_add already adds, dont do it twice.
> 
> Avi. This should go to Linus before 2.6.24.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> ---
>  fs/proc/array.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23/fs/proc/array.c
> ===================================================================
> --- linux-2.6.23.orig/fs/proc/array.c
> +++ linux-2.6.23/fs/proc/array.c
> @@ -446,7 +446,7 @@ static int do_task_stat(struct task_stru
>  			maj_flt += sig->maj_flt;
>  			utime = cputime_add(utime, sig->utime);
>  			stime = cputime_add(stime, sig->stime);
> -			gtime += cputime_add(gtime, sig->gtime);
> +			gtime = cputime_add(gtime, sig->gtime);
>  		}
>  
>  		sid = signal_session(sig);
> 


-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond

