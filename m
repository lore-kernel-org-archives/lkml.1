Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbXJNUeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbXJNUeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbXJNUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:34:28 -0400
Received: from main.gmane.org ([80.91.229.2]:57540 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbXJNUe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:34:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [NOT VERY SAFE]     [TCP]: Set initial_ssthresh default to zero
 in Cubic and BIC.
Date: Sun, 14 Oct 2007 13:34:05 -0700
Organization: Linux Foundation
Message-ID: <20071014133405.656e899a@freepuppy.rosehill>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
	<20071014100245.914b784a.komurojun@nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <20071014100245.914b784a.komurojun@nifty.com>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 10:02:45 +0900
Komuro <komurojun@nifty.com> wrote:

> Dear David
> 
> Actually, tcp_sk(sk)->snd_ssthresh is not initialized,
> if initial_ssthresh is 0.
> 
> The patch should be
> 
>  static void bictcp_init(struct sock *sk)
>  {
>  	bictcp_reset(inet_csk_ca(sk));
> -	if (initial_ssthresh)
> -		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
> +
> +	tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
>  }
>

In which case it is zero because that is the default value.

If you want to make arguments about sshtresh value, you need to provide
tcp traces of good vs problematic connection and get a good idea of
what the intermediate path and remote host OS is.  Since you are
the first to raise the issue, you will have to provide a lot of evidence
to overcome the developer suspicion that the problem is due to
buggy middle boxes, hardware or the other end.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

