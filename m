Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZJ2PXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZJ2PXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZJ2PXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:23:51 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:41262 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZJ2PXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:23:50 -0400
Message-ID: <879da81bfa8a9f0f34717c64b08332ed.squirrel@webmail.uio.no>
Date: Thu, 29 Oct 2009 16:23:53 +0100
Subject: Re: [PATCH 3/3] net: TCP thin dupack
From: apetlund@simula.no
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Andreas Petlund" <apetlund@simula.no>, "Netdev" <netdev@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       "David Miller" <davem@davemloft.net>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-UiO-Ratelimit-Test: rcpts/h 20 msgs/h 3 sum rcpts/h 31 sum msgs/h 5 total rcpts 424 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 3DA9E59205CACD7CB47ECEC965B14F322C152F1C
X-UiO-SPAM-Test: remote_host: 129.240.4.214 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 190 total 1919867 max/h 678 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologise that some of you received this mail more than once. My email
client played a HTML-trick on me.

>> +	/* If a thin stream is detected, retransmit after first
>> +	 * received dupack */
>> +	if ((tp->thin_dupack || sysctl_tcp_force_thin_dupack) &&
>> +	    tcp_dupack_heurestics(tp) > 1 && tcp_stream_is_thin(tp))
>> +		return 1;
>> +
>>  	return 0;
>>  }
>
> Have you tested it? ...I doubt this will work like you say and
retransmit
> something when the window is small. ...Besides, you should have built
this
> patch on top of the function rename you submitted earlier as after DaveM
applied that this will no longer even compile...
>
> --
>  i.
>

We have performed extensive tests mapping the effect of the patch you
commented on some months ago. Since then, the only change was the one you
requested of switching tcp_fackets_out() with tcp_dupack_heurestics().
After inspecting the code, I believed the effect should be equal to the
previous, only making considerations for SACK and FACK availability.
Please tell if this will break the intended effect, and I will modify the
patch accordingly.

Graphs from our tests of the original patch can be found at the location
linked to below.  I have tested the new one for functionality, but have
not et performed tests on this scope as the changes were minor. I will, of
course, fix the function rename in the next iteration. Sorry for that.

http://folk.uio.no/apetlund/lktmp/

-AP




