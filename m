Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbXAXNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbXAXNxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXAXNxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:53:18 -0500
Received: from pat.uio.no ([129.240.10.15]:53632 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXAXNxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:53:18 -0500
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 08:53:17 EST
Message-ID: <60609.129.240.228.21.1169645615.squirrel@webmail.uio.no>
Date: Wed, 24 Jan 2007 14:33:35 +0100 (CET)
Subject: Retransmission and packet handling in the TCP-code
From: kristrev@student.matnat.uio.no
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
References: 
In-Reply-To: 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-4.1, required=12.0, autolearn=disabled, AWL=0.336,NO_REAL_NAME=0.55,UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: 69F7579DD536F04325F98AC92E76B0AC53C5A3B8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -40 maxlevel 200 minaction 2 bait 0 mail/h: 930 total 82075 max/h 1952 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have recently started working with the Linux-kernel TCP-code with
regards to implementing a few (hopefully good) algorithms. But I want to
make sure that I have understood everything correctly before I start
implementing, so I have a few questions.

1. Are the skb's aware of the sk_buff_head? E.g. does the prev pointer of
the last skb (the one that buff_head->next points to) in the write queue
point to buff_head or to the first skb?

2. Is the "only" thing that seperates a for instance lost packet from a
recently queued one the value of the tcp_skb_cb->sacked-variable (from the
kernels point of view)? (Except for the fact that send_head might point to
the recently queued one).

3. When a retransmission occur, are all the lost packets resent or just
n-1 of them? A couple of my friends claim that the latter is true, but I
can't find anything in the source code to support that. My theory is that
they (my friends) don't count the packet that triggers the retransmission,
even though this is also retransmitted.

4. Does the kernel bundle two and two packets (if possible) during
retransmission? The same friends that told me about the n-1-thing, also
told me that the kernel tries to bundle as many packets as possible.

But I can't find anything in the code to support this, as far as can see
it tries to bundle two packets (skb's) and sends the new packet (or this
first one, if the collapse wasnt succsessful) to tcp_transmit_skb() (and
then it is to late to bundle any more).

5. Say that you have sent three packets (called p1, p2 and p3) and p2
arrives succsessfully, but p1 doesn't and triggers a timeout. If I have
understod the code correctly, the kernel will try to collapse p1 and p3
and send the combined packet if successfully (or just p1).

If we assume that the collapse took place and that p3 got lost, how does
the reciever detect what part of the data (in the packet) belongs to p1
and p3? To me it seems that tcp_retrans_try_collapse() appends all the
data from (in this case) p3 to the data-field of p1, without e.g. marking
that the last 25 bytes belongs to p3.

Thanks in advance for any answers and have a good day :)

-Kristian




