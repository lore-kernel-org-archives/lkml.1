Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXJKHvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXJKHvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXJKHvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:51:39 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48185 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbXJKHvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:51:39 -0400
Message-Id: <1192089094.29099.1215299673@webmail.messagingengine.com>
X-Sasl-Enc: MAJS9C6v4+xSnzYiLArnU2/AdXXLbUUm+c/nj/WWkFZB 1192089094
From: "Jupe" <jupejupe@rushpost.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1192028669.25145.1215155009@webmail.messagingengine.com>
   <Pine.LNX.4.61.0710101141590.17013@chaos.analogic.com>
Subject: Re: Ethernet driver problem
In-Reply-To: <Pine.LNX.4.61.0710101141590.17013@chaos.analogic.com>
Date: Thu, 11 Oct 2007 00:51:34 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply

I have tested my program on PC and it works without any problem.

I have enabled auto negotiation.  The status register shows successful
completion of auto-negotiation.
And it shows using full duplex.

I did check whether the packets are getting dropped because of lack of
space.  But it is not the case.  I even created huge number of transmit
descriptors enough to fit 1.5 MBytes of data.  But still it slows down
after about 200 KB.  I even have used the setsockopt option available in
user program.  Nothing seems to increase the speed.

Any pointers on this would be greatly helpful

Thanking you
Jupe



On Wed, 10 Oct 2007 11:49:58 -0400, "linux-os (Dick Johnson)"
<linux-os@analogic.com> said:
> 
> On Wed, 10 Oct 2007, Jupe wrote:
> 
> > Hi,
> >
> > I have written an ethernet driver for an ARM based board.
> > Linux version: 2.6.20.1
> >
> > Ping is working fine.
> >
> > I have written a test server/client application using socket programming
> > (TCP).
> > After the connection is setup the server sends a file to the client.
> >
> > When I run server on PC and client on ARM board it works without any
> > problem.
> >
> > BUT if I run server on ARM board and client on PC, it works for some
> > time and
> > then the speed is drastically reduced. (I am sending 4k of data each
> > time.
> > after 50 sends it reduces its speed.  This happens always.)
> >
> > I did some debugging and found that after 50 sends, tcp_sendmsg() is not
> > being
> > called at the same frequency before slowdown.  Also when my driver
> > ether_tx seems to
> > be working fine.
> >
> > But still i am not able to get the reason for this behaviour.  Can
> > anyone give hints as to
> > why this is happening?
> >
> >
> > Regards
> > Jupe
> >
> > -- 
> >  Jupe
> >  jupejupe@rushpost.com
> >
> > -- 
> > http://www.fastmail.fm - mmm... Fastmail...
> 
> First, does your TCP/IP test application work okay on
> a Linux machine that does not use your new driver?
> 
> That's the first thing to test.
> 
> Next, is auto-negotiation working correctly in your
> driver? If you don't have auto-negotiation, have you
> set the Ethernet parameters correctly so that BOTH
> the server and the client use either full-duplex, or
> half-duplex, without mixing them up?
> 
> Next, make sure that you are properly handling
> transmit retries (handling all possible errors)
> in your driver. The transmitter does not want
> to drop packets if there is no room in the
> device, only the receiver should drop packets
> if there are no buffers. You do not want
> the TCP/IP replacement algorithm to request
> missing packets because this slows everything
> down. Again, in the transmitter section
> of your driver, consider data precious.
> 
> 
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
> My book : http://www.AbominableFirebug.com/
> _
> 
> 
> ****************************************************************
> The information transmitted in this message is confidential and may be
> privileged.  Any review, retransmission, dissemination, or other use of
> this information by persons or entities other than the intended recipient
> is prohibited.  If you are not the intended recipient, please notify
> Analogic Corporation immediately - by replying to this message or by
> sending an email to DeliveryErrors@analogic.com - and destroy all copies
> of this information, including any attachments, without reading or
> disclosing them.
> 
> Thank you.
-- 
  Jupe
  jupejupe@rushpost.com

-- 
http://www.fastmail.fm - Access all of your messages and folders
                          wherever you are

