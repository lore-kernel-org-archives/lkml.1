Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbXIVXJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbXIVXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXIVXJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:09:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:64643 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXIVXJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Do+kDoAQ699R0H0c1Ct8owOCRkiRYxpT6ojW64faaHYI/kQQDWTvuy/3I2UEdEg5kNyTQA2WoRvrYHJCfJF9eh2lUunRHrg/kgOHgr6w97cF8DY6OModtV/stLAZEpF807pCUJeGR5jUcuL2h8O9vPDbCvwpIJ5XKVvUaQyqLcg=
Message-ID: <e660b2250709221609l1475c061t5a1a78de4fa529f@mail.gmail.com>
Date: Sat, 22 Sep 2007 18:09:15 -0500
From: "=?ISO-8859-1?Q?Carlos_Narv=E1ez?=" <crakup@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux Router
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 This is starting to frustrate me, because it should be much simpler
than it seems to be, and I feel like I'm missing something small and
obvious.

I have two private networks, we'll say 192.168.254.0/24 and
192.168.251.0/24. And I have a linux box in the middle with addresses
192.168.254.17 and 192.168.251.10:


+---------------+ . +----------------+
¦ 192.168.251.1 +---+ 192.168.251.10 ¦ . +----------------+
+---------------+ . ¦ 192.168.254.17 +---+ 192.168.254.16 ¦
. . . . . . . . . . +----------------+ . +----------------+


There is no NAT involved.. I just want the box in the middle to pass
traffic between the two networks. Here is what I have done:

- IP Forwarding has been enabled on the router via "echo 1 >
/proc/sys/net/ipv4/ip_forward"

- A route has been configured on 192.168.251.1 to point all traffic
for 192.168.254.0/24 to 192.168.251.10.

- A route has been configured on 192.168.254.16 to point all traffic
for 192.168.251.0/24 to 192.168.254.17.

- The command "iptables -I FORWARD -j ACCEPT" has been executed.

Now.. here's what happens. 192.168.251.10 can ping both interfaces on
the router. 192.168.254.16 can also ping both interfaces on the
router. However, 192.168.251.1 cannot ping 192.168.254.16, and
likewise, 192.168.254.16 cannot ping 192.168.251.1.

What have I forgotten?

-- 
Carlos Narváez
http://www.juegopixel.com
