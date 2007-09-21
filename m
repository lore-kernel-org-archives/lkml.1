Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbXIURp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbXIURp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXIURpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:45:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45346 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXIURpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:45:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 21 Sep 2007 10:45:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nagendra Tomar <tomer_iisc@yahoo.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
In-Reply-To: <798693.92196.qm@web53705.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709211041050.15361@alien.or.mcafeemobile.com>
References: <798693.92196.qm@web53705.mail.re2.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Nagendra Tomar wrote:

> > That's not what POLLOUT means in the Unix meaning. POLLOUT indicates the 
> > ability to write, and it is not meant as to signal every time a packet 
> > (skb) is sent on the wire (and the buffer released).
> 
> Aren't they both the same ? Everytime an incoming ACK frees up a buffer
> from the retransmit queue, the writability condition is freshly asserted,
> much the same way as the readability condition is asserted everytime a 
> new data is queued in the socket receive queue (irrespective of 
> whether there was data already waiting to be read in the receive queue).
> 
> This difference in meaning of POLLOUT only arises in the ET case, which was
> not what traditional Unix poll referred to. 

Again, events here are "readability" and "writeability" and the fact that 
the lower network layer freed a buffer is not, per se, an event (unless 
before, "writeability" was tested and reported as unavailable).
In you case the solution looks pretty simple. Just create appropriately 
sized buffers, split the single sendfile into multiple buffer-sized ones, 
and recycle the buffer once each of them completes.



- Davide


