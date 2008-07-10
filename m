Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYGJURN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYGJURN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYGJUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:16:58 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:62091 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbYGJUQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:16:58 -0400
Date: Thu, 10 Jul 2008 15:16:46 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [Openipmi-developer] [PATCH] IPMI: return correct value from
 ipmi_write
In-reply-to: <4876628f.41O/uzQ5H7nSU2Vg%MRustad@gmail.com>
To: Mark Rustad <MRustad@gmail.com>
Cc: openipmi-developer@lists.sourceforge.net, wim@iguana.be,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Message-id: <48766E2E.4060701@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4876628f.41O/uzQ5H7nSU2Vg%MRustad@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is correct.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Mark Rustad wrote:
> From: Mark Rustad <MRustad@gmail.com>
>
> This patch corrects the handling of write operations to the IPMI watchdog
> to work as intended by returning the number of characters actually
> processed. Without this patch, an "echo V >/dev/watchdog" enables the
> watchdog if IPMI is providing the watchdog function.
>
> Signed-off-by: Mark Rustad <MRustad@gmail.com>
> ---
> I have not checked all of the watchdogs to see if there are others that have
> this problem, but the one I was using before using the IPMI one did work
> right. It was also a big surprise how much the default watchdog timeout
> varies from one to another. Let me tell you that the 10 second default
> for the IPMI watchdog was a real sore spot while tracking this problem down!
> This problem goes back at least as far as 2.6.20, but I generated this patch
> based on 2.6.26-rc9. I have applied, compiled and tested this fix.
>
>  drivers/char/ipmi/ipmi_watchdog.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/drivers/char/ipmi/ipmi_watchdog.c	2008-07-10 09:31:52.000000000 -0500
> +++ b/drivers/char/ipmi/ipmi_watchdog.c	2008-07-10 09:33:41.000000000 -0500
> @@ -755,9 +755,8 @@ static ssize_t ipmi_write(struct file *f
>  		rv = ipmi_heartbeat();
>  		if (rv)
>  			return rv;
> -		return 1;
>  	}
> -	return 0;
> +	return len;
>  }
>  
>  static ssize_t ipmi_read(struct file *file,
>
> -------------------------------------------------------------------------
> Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
> Studies have shown that voting for your favorite open source project,
> along with a healthy diet, reduces your potential for chronic lameness
> and boredom. Vote Now at http://www.sourceforge.net/community/cca08
> _______________________________________________
> Openipmi-developer mailing list
> Openipmi-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/openipmi-developer
>   

