Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbXISXcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbXISXcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXISXcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:32:10 -0400
Received: from web53702.mail.re2.yahoo.com ([206.190.37.23]:22417 "HELO
	web53702.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751262AbXISXcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:32:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=rWdUh9cfiGu6tKAZMasPtEblub4O6QL/E0UspIZPFFNNIDHLFK2PjErRbZj3MvoJ0O/nllt5WXFcF7R7AAGnrt5sQ3v0pVpP0FkhQMGZp+TVMQVAd8XMwcnEWZhGAwmHhxN+R7SqiHnRQ4cdo7k5h3RTCiY6nYkUdPrKIExA5M8=;
X-YMail-OSG: FAfVCjkVM1le71syKt8vEGQYDoYrytfIpZt6rL9L93o_oDmnReOqWPP6Ny6KMjWTSOPVaELfExRsJXtjPa.LtnyZt8CxxEeuOG4MV4KUDiSR9b9zI3WanRGjroclTg--
Date: Wed, 19 Sep 2007 16:32:07 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
In-Reply-To: <20070919.161037.68156707.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <608569.12944.qm@web53702.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Miller <davem@davemloft.net> wrote:

> From: Nagendra Tomar <tomer_iisc@yahoo.com>
> Date: Wed, 19 Sep 2007 15:55:58 -0700 (PDT)
> 
> >      I agree that setting SOCK_NOSPACE would have been a more elegant
> > fix. Infact I thought a lot about that before deciding on this fix.
> 
> I guess this means you also noticed that you are removing
> the one and only test of this bit too?
> 
> You can't remove this, it's critical for performance.

I'm sure you would have seen value in the check that's why the 
check is there. 

Now we have two critical points to discuss

1. How can we achieve the ET EPOLLOUT event with the SOCK_NOSPACE
   check in place ?
2. How much effect will removing the check have (if we cannot 
   find a way to get the ET EPOLLOUT notification w/ the check
   in place) ? 

Regding (2), IMHO for a "fast sender" the SOCK_NOSPACE check will
almost always pass as the sender will come back to write (or poll)
before the prev data is drained out. If he doesn't do that, he is
not a "fast sender" by definition". A "fast sender" should always
have some data to send when he practically (per the sndbuf space) 
can.

For a "slow sender", do we really care abt the optimization ?

Thanx,
Tomar



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
