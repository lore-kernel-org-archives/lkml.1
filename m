Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYH1Quo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYH1Quo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYH1QuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:50:20 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:33892 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYH1QuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:50:19 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Thu, 28 Aug 2008 19:48:52 +0300
User-Agent: KMail/1.9.9
Cc: Joe Malicki <jmalicki@metacarta.com>, David Miller <davem@davemloft.net>,
       johnpol@2ka.mipt.ru, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
References: <20080827.201020.17601834.davem@davemloft.net> <21915755.1327801219904892242.JavaMail.root@ouachita> <20080828072218.GI26610@one.firstfloor.org>
In-Reply-To: <20080828072218.GI26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281948.52608.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My small IMHO regarding SO_TIMESTAMP.

1)Right now i have 400-500 Mbps passing router. If i will run 
5 "pings" ,simultaneous ,under _USER_ privileges(i know ping is suid), 
instead of free 20% CPU time, i will have 1-2% free CPU time. Sure i know 
ping is suid program, but it is has been "like this" since long time. By 
security psychos it will be caled DoS.

2)Usefullness of this option. What is a difference if on almost idle machine 
timestamp retrieved on higher level or lower level? 
And why we need on highly loaded server so high precision timestamp (with 
expensive timer), if in my case enabling any socket with SO_TIMESTAMP 
creating delays more than 10ms(up to 100ms)?

3)Who is most users of SO_TIMESTAMP? iputils which is installed on almost 
_ANY_ linux machine? busybox which is using same option? Many others 
userspace multiplatform applications? Or banks? I dont take much in account 
dhcpd, who is maybe abusing this option.

So there is few good solutions available (IMHO):
1)Introduce some SO_REALTIMESTAMP (anyway even SO_TIMESTAMP not defined in any 
standard) for banks and ntp folks, who need them. And even give them timespec 
instead timeval, so they will be even more happy with resolution.
2)Provide sysctl,kernel boot, or even "build time" option for "banks" to have 
high resolution(and expensive) SO_TIMESTAMP.
