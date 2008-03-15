Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYCOJdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYCOJdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 05:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYCOJc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 05:32:56 -0400
Received: from main.gmane.org ([80.91.229.2]:33206 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYCOJcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 05:32:55 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH 3/5] cleanups ntp.c (from Ingo)
Date: Sat, 15 Mar 2008 10:32:42 +0100
Message-ID: <47DB97BA.3080109@web.de>
References: <1205553852.6122.76.camel@localhost.localdomain>	 <1205553938.6122.79.camel@localhost.localdomain>	 <1205554018.6122.81.camel@localhost.localdomain> <1205554210.6122.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: lkml <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Ingo Molnar <mingo@elte.hu>
X-Gmane-NNTP-Posting-Host: p5b375663.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
In-Reply-To: <1205554210.6122.85.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> Make this file more readable by applying a consistent coding style.
> 
> No code changed.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Merged on top of Roman's very similar cleanups.
> (In other words: Blame John for the merge screwups).
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> 
> Index: linux-2.6/kernel/time/ntp.c
> ===================================================================
<snip>
> @@ -193,21 +197,20 @@ void second_overflow(void)
>  	 * Compute the phase adjustment for the next second. The offset is
>  	 * reduced by a fixed factor times the time constant.
>  	 */
> -	tick_length = tick_length_base;
> -	time_adj = shift_right(time_offset, SHIFT_PLL + time_constant);
> -	time_offset -= time_adj;
> -	tick_length += time_adj;
> +	tick_length	= tick_length_base;
> +	time_adj	= shift_right(time_offset, SHIFT_PLL + time_constant);
> +	time_offset	-= time_adj;
> +	tick_length	+= time_adj;
>  
>  	if (unlikely(time_adjust)) {
> -		if (time_adjust > MAX_TICKADJ) {
> -			time_adjust -= MAX_TICKADJ;
> -			tick_length += MAX_TICKADJ_SCALED;
> -		} else if (time_adjust < -MAX_TICKADJ) {
> -			time_adjust += MAX_TICKADJ;
> -			tick_length -= MAX_TICKADJ_SCALED;
> +		if (time_adjust > max_tickadj) {
> +			time_adjust -= max_tickadj;
> +			tick_length += scale_tickadj(max_tickadj);
> +		} else if (time_adjust < -max_tickadj) {
> +			time_adjust += max_tickadj;
> +			tick_length -= scale_tickadj(max_tickadj);
>  		} else {
> -			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
> -					NTP_INTERVAL_FREQ) << NTP_SCALE_SHIFT;
> +			tick_length += scale_tickadj(time_adjust);
>  			time_adjust = 0;
>  		}
>  	}
<snip>

Since you are at it, isn't "time_adj" a poor name since you also have a 
"time_adjust"?
-- 
Regards,
Jörg-Volker.

