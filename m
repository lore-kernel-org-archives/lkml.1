Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYE1UKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYE1UKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYE1UKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:10:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbYE1UKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:10:42 -0400
Date: Wed, 28 May 2008 13:10:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <20080527124315.131b1343@Varda>
Message-ID: <alpine.LFD.1.10.0805281307150.2958@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527124315.131b1343@Varda>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Alejandro Riveira Fernández wrote:
>  
>   Compiled and booting into 2.6.26-rc4
> 
>  1) With splash quiet on grub line it doesn't boot (or i didin't wait long
>     enough)
>  2) without quiet and splash I get into VT X filas becouse i use the evil
>     nvidia driver that's expected. But ubuntu failsafe mode (xserver with vesa
>     in low res) doesn't show up either *regression*

Can you give more details about where it stops? 

>  3) i get an oops with network manager

.. again, please give the full oops, without that we just know that "an 
oops happened".

>  4) if i try to run some sudo command it gets stuck (Crtl +C doesnt' help)
>     "ip route" gets stuck too. User programs i tried wrok fine (only ls and
>     htop). Network realted problem?

I assume it's related to the oops above - the oops probably happened while 
holding some mutex or other lock, which is why network-related stuff then 
blocks on that lock (which will never be released, since the oops killed 
the process that held it).

I suspect the oops is also why the bootup breaks, so it's likely all the 
same issue. Please save the dmesg into a file, reboot into a working 
setup, and send that. Along with hw information (it's likely related to 
your network device driver, since I've not seen an uproar of these kinds 
of problems from everybody else..).

>  5) printk times on dmesg go crazy

More details, please, again.

			Linus
