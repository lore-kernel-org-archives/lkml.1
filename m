Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZECX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZECX6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZECX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:58:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60732 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZECX6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:58:10 -0400
To: Lukasz Stelmach <stlman@poczta.fm>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
References: <49FE107A.4020406@poczta.fm>
	<20090503.144758.222061423.davem@davemloft.net>
	<49FE18C3.7040702@poczta.fm>
	<20090503.153428.07349534.davem@davemloft.net>
	<49FE1E71.6090500@poczta.fm>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 03 May 2009 16:58:02 -0700
In-Reply-To: <49FE1E71.6090500@poczta.fm> (Lukasz Stelmach's message of "Mon\, 04 May 2009 00\:45\:05 +0200")
Message-ID: <m1skjlrb79.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: stlman@poczta.fm, netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org, davem@davemloft.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Lukasz Stelmach <stlman@poczta.fm>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0490]
	*  4.0 XMBSHREFv2 RAW: bad href tag
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Temporary IPv6 address asignment
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukasz Stelmach <stlman@poczta.fm> writes:

I don't know about the rest of your patch the sysctl hunks are wrong.

> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index e76d3b2..951ba2c 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -570,15 +570,16 @@ enum {
>  	NET_IPV6_TEMP_PREFERED_LFT=13,
>  	NET_IPV6_REGEN_MAX_RETRY=14,
>  	NET_IPV6_MAX_DESYNC_FACTOR=15,
> -	NET_IPV6_MAX_ADDRESSES=16,
> -	NET_IPV6_FORCE_MLD_VERSION=17,
> -	NET_IPV6_ACCEPT_RA_DEFRTR=18,
> -	NET_IPV6_ACCEPT_RA_PINFO=19,
> -	NET_IPV6_ACCEPT_RA_RTR_PREF=20,
> -	NET_IPV6_RTR_PROBE_INTERVAL=21,
> -	NET_IPV6_ACCEPT_RA_RT_INFO_MAX_PLEN=22,
> -	NET_IPV6_PROXY_NDP=23,
> -	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
> +	NET_IPV6_DESYNC_FACTOR=16,
> +	NET_IPV6_MAX_ADDRESSES=17,
> +	NET_IPV6_FORCE_MLD_VERSION=18,
> +	NET_IPV6_ACCEPT_RA_DEFRTR=19,
> +	NET_IPV6_ACCEPT_RA_PINFO=20,
> +	NET_IPV6_ACCEPT_RA_RTR_PREF=21,
> +	NET_IPV6_RTR_PROBE_INTERVAL=22,
> +	NET_IPV6_ACCEPT_RA_RT_INFO_MAX_PLEN=23,
> +	NET_IPV6_PROXY_NDP=24,
> +	NET_IPV6_ACCEPT_SOURCE_ROUTE=26,
>  	__NET_IPV6_MAX
>  };

These are numbers used in the kernel sysctl binary ABI.  You just
changed them breaking the ABI, when you put NET_IPV6_DESYNC_FACTOR in
the middle.

> @@ -4124,6 +4167,14 @@ static struct addrconf_sysctl_table
>  			.data		=	&ipv6_devconf.max_desync_factor,
>  			.maxlen		=	sizeof(int),
>  			.mode		=	0644,
> +			.proc_handler	=	addrconf_sysctl_desync,
> +		},
> +		{
> +			.ctl_name	=	NET_IPV6_DESYNC_FACTOR,
> +			.procname	=	"desync_factor",
> +			.data		=	&ipv6_devconf.desync_factor,
> +			.maxlen		=	sizeof(int),
> +			.mode		=	0444,
>  			.proc_handler	=	proc_dointvec,
 		},

The sysctl binary abi is currently frozen and deprecated.  Which means
you should set .ctl_name = CTL_UNNUMBERED or simply omit ctl_name on
new sysctl entries.

Eric
