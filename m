Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbXHOHCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbXHOHCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXHOHCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:02:40 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:34606 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbXHOHCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:02:38 -0400
Message-ID: <46C2A505.7040008@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2007 12:32:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Documentation: fix getdelays.c example -l option and
 segv
References: <18240.1186734285@neuling.org>
In-Reply-To: <18240.1186734285@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
> Fix a couple of minor issues with the getdelays.c example code. 
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
>  Documentation/accounting/getdelays.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6-ozlabs/Documentation/accounting/getdelays.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/Documentation/accounting/getdelays.c
> +++ linux-2.6-ozlabs/Documentation/accounting/getdelays.c
> @@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t
>  	       "IO    %15s%15s\n"
>  	       "      %15llu%15llu\n"
>  	       "MEM   %15s%15s\n"
> -	       "      %15llu%15llu\n"
> +	       "      %15llu%15llu\n",

This change looks good!

>  	       "count", "real total", "virtual total", "delay total",
>  	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
>  	       t->cpu_delay_total,
> @@ -335,17 +335,17 @@ int main(int argc, char *argv[])
>  		}
>  	}
> 
> -	if (tid) {
> -		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
> -			      cmd_type, &tid, sizeof(__u32));
> -		PRINTF("Sent pid/tgid, retval %d\n", rc);
> -		if (rc < 0) {
> -			fprintf(stderr, "error sending tid/tgid cmd\n");
> -			goto done;
> +	do {
> +		if (tid) {
> +			rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
> +				      cmd_type, &tid, sizeof(__u32));
> +			PRINTF("Sent pid/tgid, retval %d\n", rc);
> +			if (rc < 0) {
> +				fprintf(stderr, "error sending tid/tgid cmd\n");
> +				goto done;
> +			}
>  		}
> -	}
> 
> -	do {
>  		int i;
> 
>  		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
> @@ -430,6 +430,7 @@ int main(int argc, char *argv[])
>  			}
>  			na = (struct nlattr *) (GENLMSG_DATA(&msg) + len);
>  		}
> +		sleep(2);

Is this really required? a sleep() in the code. Why do we do multiple send_cmd()'s
in the do loop? I'll test and get back.

>  	} while (loop);
>  done:
>  	if (maskset) {
> 
> 
> 
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
