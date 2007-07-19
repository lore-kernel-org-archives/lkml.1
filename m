Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbXGSVid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbXGSVid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbXGSViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:38:23 -0400
Received: from web56601.mail.re3.yahoo.com ([66.196.97.45]:34222 "HELO
	web56601.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753454AbXGSViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:38:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=OnqDOf1BfK8oY+nz1BYKIg9LwVRaqTJ5qVe4GSg19Y0ttm53K+iOoe0nvFrYRpSd4VtTvdNti5Bj13pvJSjZVhgKxYrPoyM45cjZ4bGFV1L4QOTzYefkITZh9Ug7Nl13Y56y5g9kHeVFJo5z8+F9b9ac1lBd8BUxY6DfqGJZAKE=;
X-YMail-OSG: HbMLBB0VM1ma1ZFgNqoH.6VGyZ00x2ovqwLzr9eFNrGnoMH7nhluJ1oHiOpxqA.ZNDGfWHbciclIblWajwfRkdpZle7qGh_Thp4gGMeCR1UBlqYTY5woLygTVxmJeL7qY7cX1qFdCYW4lBsRzdEhZk8I8Q--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.41.16
Date: Thu, 19 Jul 2007 14:38:20 -0700 (PDT)
From: andrei radulescu-banu <iubica2@yahoo.com>
Subject: Re: Linux, tcpdump and vlan
To: Patrick McHardy <kaber@trash.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <930446.33248.qm@web56601.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During debugging, I noticed that dev_queue_xmit() is called twice for tx vlan frames. This results in a frame being passed twice to a packet socket bound to 'any' interface. If the packet socket is bound to a specific interface, though, it will get only one copy of the tx frame, which is good.

In more detail: suppose we're tx'ing a frame, and the route table lookup yields a vlan outgoing device eth0.2. dev_queue_xmit() is called, which calls dev_queue_xmit_nit() for dev = eth0.2 then dev->hard_start_xmit() for dev = eth0.2. 

The latter call gets into the vlan layer, which attaches the vlan id 2 (accelerated or not... in my e1000 case accelerated) then calls dev_queue_xmit() again. This time around dev_queue_xmit_nit() is called for dev = eth0, and dev->hard_start_xmit() actually calls the ethernet driver.

The net result is that dev_queue_xmit_nit() is called twice, once for dev=eth0.2 then for dev=eth0.



      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


