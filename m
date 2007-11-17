Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXKQXpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXKQXpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 18:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbXKQXpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 18:45:25 -0500
Received: from ccerelrim01.cce.hp.com ([161.114.21.22]:24925 "EHLO
	ccerelrim01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbXKQXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 18:45:23 -0500
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Nov 2007 18:45:20 EST
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
Date: Sat, 17 Nov 2007 18:09:59 -0500
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
References: <20071116173439.796600895@I-love.SAKURA.ne.jp> <200711161423.28065.paul.moore@hp.com> <200711171245.HFH05776.LQFOtVMHOSFOFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200711171245.HFH05776.LQFOtVMHOSFOFJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171810.00404.paul.moore@hp.com>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.11.17.144310
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007 10:45:32 pm Tetsuo Handa wrote:
> Paul Moore wrote:
> > I might be missing something here, but why do you need to do a skb_peek()
> > again?  You already have the skb and the sock, just do the unlink.
>
> The skb might be already dequeued by other thread while I slept inside
> security_post_recv_datagram().

Okay, well if that is the case I think you are going to have another problem 
in that you could end up throwing away skbs that haven't been through your 
security_post_recv_datagram() hook because you _always_ throw away the result 
of the second skb_peek().  Once again, if I'm wrong please correct me.

> > Second, why not move the 'no_peek' code to just before 'no_packet'?
>
> Oh, I didn't notice I can insert here. Now I can also move the rest code
> like
>
> |		error = security_post_recv_datagram(sk, skb, flags);
> |		if (error)
> |                       goto force_dequeue;
> |
> |         } while (!wait_for_packet(sk, err, &timeo));

Where did the 'if (skb) return skb;' code go?  Don't you need to do you LSM 
call before you return the skb?

-- 
paul moore
linux security @ hp
