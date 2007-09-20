Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbXITWZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbXITWZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXITWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:24:56 -0400
Received: from web53705.mail.re2.yahoo.com ([206.190.37.26]:42751 "HELO
	web53705.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752465AbXITWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:24:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gDG9/uLr0HnaZ9MKcyeoZxSo7iCTJxHEOWCNimmW5GdtoCcZJkbdfWws2DUiOJUqWGJj6YOhfb1NdfLnGaHlcfVUAjUvEHk7TzIg203UtaTAGarO97EovqEaqcPhccL6TIWRgJixOggYf0NOeCEpAUFB6eJBC+WTKVbv9O/pSc8=;
X-YMail-OSG: sPHfC6kVM1kfCdL_4OQFmXYG2u9TJn4xyiKekshrFshoqM4A6bg_7vh3lXGM5kgpyOblvC9vLfrsTE0KrgfrayY6DeOOOLO7lZ9OPY4NvtIVhSAYuc4LEfBXiw--
Date: Thu, 20 Sep 2007 15:24:53 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Cc: Nagendra Tomar <tomer_iisc@yahoo.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709201048290.8897@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <549830.78824.qm@web53705.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Davide Libenzi <davidel@xmailserver.org> wrote:

> 
> Unfortunately f_op->poll() does not let the caller to specify the events 
> it's interested in, that would allow to split send/recevie wait queues and 
> better detect read/write cases.
> The detection of a waitqueue_active(->sk_wr_sleep) would work fine in 
> detecting is someone is actually waiting for a write, w/out the false 
> positives triggered by the read-waiters.
> That would be a very sane thing to do, but would require a big&dumb change 
> to all the ->poll around (that could be automated by a script - devices 
> not caring about the events hint can just continue to use the single queue 
> like they currently do), and a more critical and gradual change of all the 
> devices that wants to take advantage of it.
> That way, no more magic bits are needed, and a simple waitqueue_active() 
> would tell you if someone is waiting for write-space events.
> 

I like this.





      ___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
