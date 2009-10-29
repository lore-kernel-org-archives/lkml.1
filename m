Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZJ2PTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZJ2PTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZJ2PTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:19:30 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:51105 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbZJ2PTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:19:30 -0400
Message-ID: <83449a990112ea3cf5f172e7f6ee9874.squirrel@webmail.uio.no>
Date: Thu, 29 Oct 2009 16:19:33 +0100
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
From: apetlund@simula.no
To: "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>
Cc: "Eric Dumazet" <eric.dumazet@gmail.com>,
       "Andreas Petlund" <apetlund@simula.no>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       ilpo.jarvinen@helsinki.fi, davem@davemloft.net
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 14 msgs/h 2 sum rcpts/h 25 sum msgs/h 4 total rcpts 418 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: AF45B0037623377984772AC89C1C1EA5C6AB06D7
X-UiO-SPAM-Test: remote_host: 129.240.4.215 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 121 total 1923052 max/h 707 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologise that some of you received this mail more than once. My email
client played a HTML-trick on me.

> Eric Dumazet schrieb:
>> Andreas Petlund a écrit :
>>> This patch will make TCP use only linear timeouts if the stream is
thin. This will help to avoid the very high latencies that thin stream
suffer because of exponential backoff. This mechanism is only active
if
>>> enabled by iocontrol or syscontrol and the stream is identified as thin.
>> Wont this reduce the session timeout to something very small, ie 15
retransmits, way under the minute ?
>
> The session timeout no longer depends on the actual number of
retransmits.
> Instead its a time interval,
> which is roughly equivalent to the time a TCP, performing exponential
backoff would need to perform
> 15 retransmits.
>
> However, addressing the proposal:
> I wonder how one can seriously suggest to just skip congestion response
during timeout-based
> loss recovery? I believe that in a heavily congested scenarios, this
would
> lead to a goodput
> goodput disaster... Not to mention that in a heavily congested scenario,
suddenly every flow
> will become "thin", so this will even amplify the problems. Or did I
miss
> something?

We have found no noticeable degradation of the goodput in a series of
experiments we have performed in order to map the effects of the
modifications. Furthermore, the modifications implemented in the patches
are explicitly enabled only for applications where the developer knows
that streams will be thin, thus only a small subset of the streams will
apply the modifications.

Graphs presenting results from experiments performed to analyse latency
and fairness issues can be found here:
http://folk.uio.no/apetlund/lktmp/

-AP


