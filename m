Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbXKSPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbXKSPuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXKSPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:50:43 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:8141 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbXKSPun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:50:43 -0500
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 10:50:42 EST
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
Date: Mon, 19 Nov 2007 10:39:41 -0500
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
References: <20071116173439.796600895@I-love.SAKURA.ne.jp> <200711190836.12940.paul.moore@hp.com> <200711192329.JGB18772.tLHOOSMVFFQOFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200711192329.JGB18772.tLHOOSMVFFQOFJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711191039.41533.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 November 2007 9:29:52 am Tetsuo Handa wrote:
> Paul Moore wrote:
> > If that is the case then the second call to
> > skb_peek() will return a different skb then the one you passed to
> > security_post_recv_datagram().
>
> Yes. The second call to skb_peek() might return a different skb than the
> one I passed to security_post_recv_datagram().

My apologies, I mistakenly read the following if statement in your patch:

 +       if (skb == skb_peek(&sk->sk_receive_queue)) {
 +               __skb_unlink(skb, &sk->sk_receive_queue);
 +               atomic_dec(&skb->users);
 +       }

I read the conditional as the following:

 +       if (skb = skb_peek(&sk->sk_receive_queue)) {

... which would have caused the problems I was describing.  I'm sorry for all 
of the confusion/frustration, you patient explanations are correct; I was 
wrong in this particular case.

-- 
paul moore
linux security @ hp
