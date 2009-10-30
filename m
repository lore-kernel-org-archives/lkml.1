Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZJ3OK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZJ3OK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbZJ3OK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:10:57 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:38672 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbZJ3OK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:10:56 -0400
Message-ID: <644ddf8802a85c425aaf86c191161fa4.squirrel@webmail.uio.no>
Date: Fri, 30 Oct 2009 15:11:00 +0100
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
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 467 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B85243B0E8095FC12F739C66D7F3D00197FD47A8
X-UiO-SPAM-Test: remote_host: 129.240.4.214 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 67 total 1925079 max/h 678 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 29 Oct 2009, apetlund@simula.no wrote:
>
>> I apologise that some of you received this mail more than once. My
email
>> client played a HTML-trick on me.
>> >> +	/* If a thin stream is detected, retransmit after first
>> >> +	 * received dupack */
>> >> +	if ((tp->thin_dupack || sysctl_tcp_force_thin_dupack) &&
>> >> +	    tcp_dupack_heurestics(tp) > 1 && tcp_stream_is_thin(tp))
+		return 1;
>> >> +
>> >>  	return 0;
>> >>  }
>> >
>> > Have you tested it? ...I doubt this will work like you say and
>> retransmit
>> > something when the window is small. ...Besides, you should have built
>> this
>> > patch on top of the function rename you submitted earlier as after
>> DaveM
>> applied that this will no longer even compile...
>> >
>> > --
>> >  i.
>> >
>> We have performed extensive tests mapping the effect of the patch you
commented on some months ago. Since then, the only change was the one
you
>> requested of switching tcp_fackets_out() with tcp_dupack_heurestics().
After inspecting the code, I believed the effect should be equal to the
previous, only making considerations for SACK and FACK availability.
Please tell if this will break the intended effect, and I will modify
the
>> patch accordingly.
>
> Ah, you're of course right. FACK retransmits the head always but RFC3517
mode doesn't. I think you'd need to artificially lower (ie., to
calculate)
> the dupthresh (from tp->reordering) to be 1 for it to work as intented.
>
>> Graphs from our tests of the original patch can be found at the
location
>> linked to below.  I have tested the new one for functionality, but have
not et performed tests on this scope as the changes were minor. I will,
of
>> course, fix the function rename in the next iteration. Sorry for that.
http://folk.uio.no/apetlund/lktmp/
>
> You curiousity, have you run this more aggressive form of early
retransmit
> against the one ID gives? ...I checked your results but if I understood
them correctly the IDish early retransmit wasn't among the variants
used.

We have not implemented EFR for Linux TCP. We have, however, performed
tests where we compare the Free BSD implementation on SCTP with SCTP using
our proposed exp. bo. and dupACK modifications.  I know that this is not
directly comparable, and link to this as a digression:

http://folk.uio.no/apetlund/lktmp/SCTP_thin_compare.pdf

If you are interested in our set of SCTP experiments, it is summarised in
the paper linked to below:

http://simula.no/research/networks/publications/Simula.ND.311/simula_pdf_file

Regards,
Andreas




