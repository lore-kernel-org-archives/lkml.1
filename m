Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZJ2U0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZJ2U0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZJ2U0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:26:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44036 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbZJ2U0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:26:45 -0400
Date: Thu, 29 Oct 2009 22:26:49 +0200 (EET)
From: "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@melkinkari.cs.Helsinki.FI
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
cc: Andreas Petlund <apetlund@simula.no>,
       William Allen Simpson <william.allen.simpson@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       Christian Samsel <Christian.Samsel@rwth-aachen.de>
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
In-Reply-To: <4AE9C396.3040705@nets.rwth-aachen.de>
Message-ID: <Pine.LNX.4.64.0910292215420.14335@melkinkari.cs.Helsinki.FI>
References: <4AE72075.4070702@simula.no> <4AE7B5D6.8070001@gmail.com>
 <38EB8C31-A96A-4C5C-88D8-8F6BF0E9225F@simula.no> <4AE9C396.3040705@nets.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Arnd Hannemann wrote:

> Andreas Petlund schrieb:
> > Den 28. okt. 2009 kl. 04.09 skrev William Allen Simpson:
> > 
> >> Andreas Petlund wrote:
> >>> +/* Determines whether this is a thin stream (which may suffer from
> >>> + * increased latency). Used to trigger latency-reducing mechanisms.
> >>> + */
> >>> +static inline unsigned int tcp_stream_is_thin(const struct  
> >>> tcp_sock *tp)
> >>> +{
> >>> +	return tp->packets_out < 4;
> >>> +}
> >>> +
> >> This bothers me a bit.  Having just looked at your Linux presentation,
> >> and not (yet) read your papers, it seems much of your justification  
> >> was
> >> with 1 packet per RTT.  Here, you seem to be concentrating on 4,  
> >> probably
> >> because many implementations quickly ramp up to 4.
> >>
> > 
> > The limit of 4 packets in flight is based on the fact that less than 4  
> > packets in flight makes fast retransmissions impossible, thus limiting  
> > the retransmit options to timeout-retransmissions. The criterion is  
> 
> There is Limited Transmit! So this is generally not true.
> 
> > therefore as conservative as possible while still serving its purpose.  
> > If further losses occur, the exponential backoff will increase latency  
> > further. The concept of using this limit is also discussed in the  
> > Internet draft for Early Retransmit by Allman et al.:
> > http://www.icir.org/mallman/papers/draft-ietf-tcpm-early-rexmt-01.txt
> 
> This ID is covering exactly the cases which Limited Transmit does not
> cover and works "automagically" without help of application. So why not
> just implement this ID?

I even gave some advise recently to one guy how to polish up the early 
retransmit implementation of his. ...However, I think we haven't heard 
from that since then... I added him as CC if he happens to have it already 
done.

It is actually so that patches 1+3 implement sort of an early retransmit, 
just slightly more aggressive of it than what is given in ID but I find 
the difference in the aggressiveness rather insignificant. ...Whereas the 
RTO stuff is more questionable.


-- 
 i.
