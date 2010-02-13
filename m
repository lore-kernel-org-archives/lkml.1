Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0BMP67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 10:58:59 -0500
Received: from mail.2750.no ([62.101.244.198]:59379 "EHLO mail.2750.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab0BMP6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 10:58:11 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 10:58:09 EST
Message-ID: <4B76CA28.5060709@simula.no>
Date: Sat, 13 Feb 2010 16:50:00 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100213 Shredder/3.0.2pre
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       =?UTF-8?B?SWxwbyBK?= =?UTF-8?B?w6RydmluZW4=?= 
	<ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, damian@tvk.rwth-aachen.de
Subject: Re: [net-next PATCH v3 2/3] net: TCP thin linear timeouts
References: <4B73F30D.6040205@simula.no> <4B753931.30405@gmail.com>
In-Reply-To: <4B753931.30405@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12. feb. 2010 12:19, William Allen Simpson wrote:
> Last year, I'm pretty sure I was on record as thinking this is only a
> marginally good idea, that would be better at the application layer.
> 
> Also that naming was a bit dicey.  Now the names are more descriptive,
> but the "force" is a bit overkill.
> 
> How about?
>   NET_TCP_FORCE_THIN_LINEAR_TIMEOUTS    -> NET_TCP_THIN_LINEAR_TIMEOUTS
>   TCP_THIN_LT                           -> TCP_THIN_LINEAR_TIMEOUTS
>   TCP_THIN_LT_RETRIES                   -> TCP_THIN_LINEAR_RETRIES
>   tcp_force_thin_linear_timeouts        -> tcp_thin_linear_timeouts
>   sysctl_tcp_force_thin_linear_timeouts -> sysctl_tcp_thin_linear_timeouts
>   tp->thin_lt                           -> tp->thin_lto
> 
> The latter mostly traditional "to" for "timeout", as used most everywhere.
> 

I agree that the _force_-part should be taken out for both patches, and 
renaming the lt to lto also makes sense. I'll fix it in the next iteration.

> Just for efficiency, I'd reorder this
>   +    if (sk->sk_state == TCP_ESTABLISHED &&
>   +        (tp->thin_lt || sysctl_tcp_force_thin_linear_timeouts) &&
>   +        tcp_stream_is_thin(sk) &&
>   +        icsk->icsk_retransmits <= TCP_THIN_LT_RETRIES) {

Thank you for this suggestion. I'll reorder in the next iteration.

Best regards,
Andreas
