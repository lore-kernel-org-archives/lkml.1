Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbZJ1DJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbZJ1DJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932482AbZJ1DJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:09:09 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:56478 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbZJ1DJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UF85Yxp9INuizBl+VU2a/rt36RszIG0MoYVZH2K1IxpHPKrzLG7nJ3kuvl4Z0YRPnC
         9rB4inFz7gaK8w9iP1fVlZyeEM2da+7c6tWMdXS/BH/R0+El5ouwgrOkxVlrfBZq/4BH
         isTZ/Po7/C5XmiuF/aaWuTBWO1heiBEBJrtVw=
Message-ID: <4AE7B5D6.8070001@gmail.com>
Date: Tue, 27 Oct 2009 23:09:10 -0400
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
References: <4AE72075.4070702@simula.no>
In-Reply-To: <4AE72075.4070702@simula.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Petlund wrote:
> +/* Determines whether this is a thin stream (which may suffer from
> + * increased latency). Used to trigger latency-reducing mechanisms.
> + */
> +static inline unsigned int tcp_stream_is_thin(const struct tcp_sock *tp)
> +{
> +	return tp->packets_out < 4;
> +}
> +
This bothers me a bit.  Having just looked at your Linux presentation,
and not (yet) read your papers, it seems much of your justification was
with 1 packet per RTT.  Here, you seem to be concentrating on 4, probably
because many implementations quickly ramp up to 4.

But there's a fair amount of experience showing that ramping to 4 is
problematic on congested paths, especially wireless networks.  Fast
retransmit in that case would be disastrous.

Once upon a time, I worked on a fair number of interactive games a decade
or so ago.  And agree that this can be a problem, although I've never
been a fan of turning off the Nagle algorithm.  My solution has always
been a heartbeat, rather than trying to shoehorn this into TCP.

Also, I've not seen any discussion on the end-to-end interest list.

