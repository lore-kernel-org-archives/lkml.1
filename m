Return-Path: <linux-kernel-owner+w=401wt.eu-S933737AbXKPR52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbXKPR52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbXKPR5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:57:13 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:33583 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbXKPR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:57:10 -0500
Date: Sat, 17 Nov 2007 02:57:08 +0900 (JST)
Message-Id: <20071117.025708.29947074.yoshfuji@linux-ipv6.org>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       yoshfuji@linux-ipv6.org
Subject: Re: [TOMOYO #5 11/18] Network access control functions.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20071116173527.282964575@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<20071116173527.282964575@I-love.SAKURA.ne.jp>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In article <20071116173527.282964575@I-love.SAKURA.ne.jp> (at Sat, 17 Nov 2007 02:34:50 +0900), penguin-kernel@I-love.SAKURA.ne.jp says:

> +	*cp++ = '\0';
> +	count = sscanf(cp,
> +		       NIP6_FMT "-" NIP6_FMT,
> +		       &min[0], &min[1], &min[2], &min[3],
> +		       &min[4], &min[5], &min[6], &min[7],
> +		       &max[0], &max[1], &max[2], &max[3],
> +		       &max[4], &max[5], &max[6], &max[7]);
> +

I think you can use in6_pton() here.

> +	count = sscanf(cp,
> +		       NIPQUAD_FMT "-" NIPQUAD_FMT,
> +		       &min[0], &min[1],
> +		       &min[2], &min[3],
> +		       &max[0], &max[1],
> +		       &max[2], &max[3]);
> +

in4_pton().

> +
> +/**
> + * tmy_print_ipv6 - print ipv6 address
> + * @buffer:     pointer to buffer to save the result.
> + * @buffer_len: sizeof @buffer .
> + * @ip:         pointer to an IPv6 address in network byte order.
> + *
> + * Returns @buffer .
> + */
> +char *tmy_print_ipv6(char *buffer, const int buffer_len, const u16 *ip)
> +{
> +	memset(buffer, 0, buffer_len);
> +	snprintf(buffer, buffer_len - 1, NIP6_FMT,
> +		 ntohs(ip[0]), ntohs(ip[1]), ntohs(ip[2]), ntohs(ip[3]),
> +		 ntohs(ip[4]), ntohs(ip[5]), ntohs(ip[6]), ntohs(ip[7]));
> +	return buffer;
> +}
> +

snprintf(buffer, buffer_len - 1, NIP6_FMT, NIP6(*(struct in6_addr *)ip));

> +	count = sscanf(cp2,
> +		       NIP6_FMT "-" NIP6_FMT,
> +		       &min[0], &min[1], &min[2], &min[3],
> +		       &min[4], &min[5], &min[6], &min[7],
> +		       &max[0], &max[1], &max[2], &max[3],
> +		       &max[4], &max[5], &max[6], &max[7]);
> +

again, in6_pton().

> +	count = sscanf(cp2,
> +		       NIPQUAD_FMT "-" NIPQUAD_FMT,
> +		       &min[0], &min[1], &min[2], &min[3],
> +		       &max[0], &max[1], &max[2], &max[3]);
> +

in4_pton().

--yoshfuji
