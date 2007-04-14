Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXDNHw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXDNHw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 03:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161158AbXDNHw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 03:52:26 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:34722
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161140AbXDNHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 03:52:25 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 03:52:25 EDT
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Transfer-Encoding: 7bit
Message-Id: <8925FF2E-4B6E-459A-A1BF-E0488F6EDC13@it-loops.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Michael Guntsche <mike@it-loops.com>
Subject: Marked based routing and redirecting problems with kernel v2.6
Date: Sat, 14 Apr 2007 09:45:41 +0200
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I recently switched one of my older gateways from 2.4 to 2.6. I had a  
transparent proxy set-up as explained
here http://www.faqs.org/docs/Linux-mini/TransparentProxy.html#ss6.2
I know that transparent proxying is generally being frowned on but in  
this special case I have to use it.
This setup worked fine with the v2.4 kernel on my gateway. After  
switching to 2.6 it seems that the packets are no longer routed to my  
squid box correctly.
I see the first sync from the client and get the reply sync from the  
squid box, but the ACK my client sends back never reaches the squid  
box. So the squid box is sending out SYNC requests again and after a  
very long time it sometimes "sees" the ACK from the client.

This is an example of a successful connection with the 2.4 kernel  
running on the gateway.


Gateway/Router:

09:31:11.718565 IP trillian.comsick.at.49282 > www.heise.de.www: S  
1286769610:1286769610(0) win 65535 <mss 1460,nop,wscale  
0,nop,nop,timestamp 988726717 0,sackOK,eol>
09:31:11.718836 IP trillian.comsick.at.49282 > www.heise.de.www: S  
1286769610:1286769610(0) win 65535 <mss 1460,nop,wscale  
0,nop,nop,timestamp 988726717 0,sackOK,eol>
09:31:11.719632 IP trillian.comsick.at.49282 > www.heise.de.www: .  
ack 598485927 win 65535 <nop,nop,timestamp 988726717 10262916>
09:31:11.719725 IP trillian.comsick.at.49282 > www.heise.de.www: .  
ack 1 win 65535 <nop,nop,timestamp 988726717 10262916>

Squid Box:

09:31:10.795018 IP trillian.comsick.at.49282 > www.heise.de.www: S  
1286769610:1286769610(0) win 65535 <mss 1460,nop,wscale  
0,nop,nop,timestamp 988726717 0,sackOK,eol>
09:31:10.797621 IP www.heise.de.www > trillian.comsick.at.49282: S  
598485926:598485926(0) ack 1286769611 win 5792 <mss  
1460,sackOK,timestamp 10262916 988726717,nop,wscale 2>
09:31:10.795831 IP trillian.comsick.at.49282 > www.heise.de.www: .  
ack 1 win 65535 <nop,nop,timestamp 988726717 10262916>

Not working with V2.6 with no changes in the setup

Gateway/Router:

09:39:33.798241 IP trillian.comsick.at.49303 > www.heise.de.www: S  
1751958343:1751958343(0) win 65535 <mss 1460,nop,wscale  
0,nop,nop,timestamp 988727720 0,sackOK,eol>
09:39:33.807231 IP trillian.comsick.at.49303 > www.heise.de.www: S  
1751958343:1751958343(0) win 65535 <mss 1460,nop,wscale  
0,nop,nop,timestamp 988727720 0,sackOK,eol>
09:39:33.798996 IP trillian.comsick.at.49303 > www.heise.de.www: .  
ack 1144270693 win 65535 <nop,nop,timestamp 988727720 10388336>

Squid Box:

09:39:32.480764 IP trillian.comsick.at.49303 > www.heise.de.www: S  
1751958343:1751958343(0) win 65535 <mss 1460,nop,wscale  
0,nop,nop,timestamp 988727720 0,sackOK,eol>
09:39:32.482965 IP www.heise.de.www > trillian.comsick.at.49303: S  
1144270692:1144270692(0) ack 1751958344 win 5792 <mss  
1460,sackOK,timestamp 10388336 988727720,nop,wscale 2>
... retries ...

As you can see the ACK never reaches the SQUID box.

Am I missing something or has the handling of this special packet  
mangling changed in v2.6?
This has been tested with 2.6.19 and 2.6.20.6
Please put me on CC for any reply since I am not subscribed to the list.

Kind regards,
Michael
