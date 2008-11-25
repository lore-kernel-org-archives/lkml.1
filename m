Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYKYD1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYKYD1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 22:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYKYD1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 22:27:36 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:37405 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYKYD1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 22:27:35 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 22:27:34 EST
In-Reply-To: <200808041526.08332.IvDoorn@gmail.com>
References: <20080620175729.GA3151@ime.usp.br> <20080620195815.GA2703@ime.usp.br> <20080625194937.GA13636@ime.usp.br> <200808041526.08332.IvDoorn@gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <3977BB08-9149-41E4-B187-235F36204E4E@ime.usp.br>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Still some problems with the rt2x00 driver
Date: Tue, 25 Nov 2008 01:19:10 -0200
To: Ivo van Doorn <ivdoorn@gmail.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, Ivo, John and others.

On Aug 04 2008, Ivo van Doorn wrote:
> I have found the problem and have send it upstream so the patch  
> should be
> present in 2.6.27.

Well, it works ok (but see below) on powerpc, with a 2.6.27 kernel (I  
still have not upgraded it).

There are two strange things that I've noticed, though and that I  
feel need to be fixed:

1 - the rt63 driver used by a PCMCIA card DWL-G630 model has, for  
many kernels (from 2.6.24 and up to and including kernel 2.6.27, as  
shipped by Ubuntu for ia32), shown a strange behavior: after  
everything is working correctly, the network simply becomes  
unavailable, with the gnome network monitor showing that the card has  
no signal. If I issue the command "iwconfig ra0 ap any", for example,  
the card starts working again.

(Actually, I put this on a cron job to be executed every minute, but  
even then, there are time windows where the card is not working). I'm  
not in front of the notebook (a very old Armada V300 that my parents  
are using for production), so I don't know if the card looses  
association with the Access Point or not. I can check that, if nobody  
else reported this problem yet.

2 - the rt2500usb driver that I use on a very old iBook G3 (powerpc)  
also works fine and has a similar, but not identical behaviour: the  
DWL-G122 USB stick that I have works fine once associated and when it  
is transferring data. Once I leave the network unused for, say, 2  
minutes, the connection with the AP is dropped. Here, also, issuing  
"iwconfig wlan0 ap any" makes it work again.

Notice the difference in both cases: with the PCMCIA/ia32 case, no  
matter if there is traffic on the network or not, the the connection  
is interrupted. With the USB/powerpc case, if there is traffic, the  
connection remains working fine.

> Note that I am not going to push it to 2.6.26 since I don't know if  
> the
> patch will cause problems in other parts of the driver.

There's no problem. I can compile vanilla kernels from kernel.org  
without any problems.


Thanks for your kind help, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org