Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbYCUXS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbYCUXS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbYCUXHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:07:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:55362 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbYCUXHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:07:47 -0400
Message-ID: <47E43FBE.90600@googlemail.com>
Date: Sat, 22 Mar 2008 00:07:42 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com,
       netdev@vger.kernel.org
Subject: Re: Commit 270637abff0cdf848b910b9f96ad342e1da61c66 introduced a
 lot new compiler warnings
References: <47E40856.6020902@googlemail.com> <20080321.154340.210302849.davem@davemloft.net>
In-Reply-To: <20080321.154340.210302849.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Gabriel C <nix.or.die@googlemail.com>
> Date: Fri, 21 Mar 2008 20:11:18 +0100
> 
>> I noticed the following new compile warnings on current git head introduced by 270637abff0cdf848b910b9f96ad342e1da61c66 :
> 
> Please include netdev@vger.kernel.org for networking bug
> reports in the future, thank you.

I usually do that and to be honest I thought I did , damn fingers.

Really sorry.

> 
> Thanks for the report, I'll push the following fix:
> 
> commit 1233823b0847190976d69a86d7bb1287992ba2c7
> Author: David S. Miller <davem@davemloft.net>
> Date:   Fri Mar 21 15:40:47 2008 -0700
> 
>     [SCTP]: Fix build warnings with IPV6 disabled.
>     
>     Introduced by 270637abff0cdf848b910b9f96ad342e1da61c66
>     ("[SCTP]: Fix a race between module load and protosw access")
>     
>     Reported by Gabriel C:
>     
>     In file included from net/sctp/sm_statetable.c:50:
>     include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
>     include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
>     In file included from net/sctp/sm_statefuns.c:62:
>     include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
>     include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
>      ...
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 57ed3e3..ea80673 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -389,7 +389,7 @@ void sctp_v6_del_protocol(void);
>  
>  #else /* #ifdef defined(CONFIG_IPV6) */
>  
> -static inline void sctp_v6_pf_init(void) { return 0; }
> +static inline void sctp_v6_pf_init(void) { return; }
>  static inline void sctp_v6_pf_exit(void) { return; }
>  static inline int sctp_v6_protosw_init(void) { return 0; }
>  static inline void sctp_v6_protosw_exit(void) { return; }
> 

It fixes all warnings , thx.

Gabriel
