Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbXKSNg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbXKSNg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXKSNgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:36:18 -0500
Received: from smtp.cce.hp.com ([161.114.21.25]:15459 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbXKSNgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:36:17 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
Date: Mon, 19 Nov 2007 08:36:12 -0500
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
References: <20071116173439.796600895@I-love.SAKURA.ne.jp> <200711171810.00404.paul.moore@hp.com> <200711181300.III52155.FtFQJOLSMOHOVF@I-love.SAKURA.ne.jp>
In-Reply-To: <200711181300.III52155.FtFQJOLSMOHOVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711190836.12940.paul.moore@hp.com>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.11.19.50841
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2007 11:00:20 pm Tetsuo Handa wrote:
> Hello.

Hello.

> Paul Moore wrote:
> > Okay, well if that is the case I think you are going to have another
> > problem in that you could end up throwing away skbs that haven't been
> > through your security_post_recv_datagram() hook because you _always_
> > throw away the result of the second skb_peek().  Once again, if I'm wrong
> > please correct me.
>
> I didn't understand what's wrong with throwing away the result of
> the second skb_peek().

My concern is that you stated earlier that you needed to do the second 
skb_peek() because the first skb may have been removed from the socket queue 
while your LSM was making an access decision in 
security_post_recv_datagram().  If that is the case then the second call to 
skb_peek() will return a different skb then the one you passed to 
security_post_recv_datagram().  This is significant because you always throw 
away this second skb without first consulting the LSM via 
security_post_recv_datagram().

-- 
paul moore
linux security @ hp
