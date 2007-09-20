Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXITW7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXITW7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXITW67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:58:59 -0400
Received: from web53705.mail.re2.yahoo.com ([206.190.37.26]:46230 "HELO
	web53705.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751296AbXITW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:58:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Jc5Hl6CJO6xq+Q752nrOW5MdjmWJsTkVyVdBKAPRO95QZfK+h+gHgfE8Ol6J7ciDQJt54AFgmhNSPmfMpvRRXtGQhNoJfXl8p46lcr5NLBIHifix0F9HXKe4e+ckunnQR43rBE3QWZ5Vs10g1QbtOs6OWpOBpA+LqDYTXCPo4VE=;
X-YMail-OSG: kL807dQVM1npS.M4BJwsudX4iV4pkhn7mvq3LEejnAwFOFjTU42srOh3FzsWmaa1CSmvv3jsWwHeU_zNPrTE7cxX0xLu8GaiIS57sdX7vkBWtwqJ7CgMEl4sljdMspJA4IBg.3kQdt_OAxRxbRdXZ0p2gw--
Date: Thu, 20 Sep 2007 15:58:57 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: Davide Libenzi <davidel@xmailserver.org>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0709201518540.8897@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <798693.92196.qm@web53705.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Davide Libenzi <davidel@xmailserver.org> wrote:


> That's not what POLLOUT means in the Unix meaning. POLLOUT indicates the 
> ability to write, and it is not meant as to signal every time a packet 
> (skb) is sent on the wire (and the buffer released).

Aren't they both the same ? Everytime an incoming ACK frees up a buffer
from the retransmit queue, the writability condition is freshly asserted,
much the same way as the readability condition is asserted everytime a 
new data is queued in the socket receive queue (irrespective of 
whether there was data already waiting to be read in the receive queue).

This difference in meaning of POLLOUT only arises in the ET case, which was
not what traditional Unix poll referred to. 

Since its a new game the rules can be modified (ofcourse based on the 
merits i.e. usability)

Thanx,
Tomar





      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
