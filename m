Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXAVVLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXAVVLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbXAVVLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:11:11 -0500
Received: from cpe.atm2-0-5496.0x50a2bf66.kjnxx5.customer.tele.dk ([80.162.191.102]:25490
	"EHLO bangat.vink-slott.dk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932659AbXAVVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:11:10 -0500
X-Greylist: delayed 1367 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jan 2007 16:11:10 EST
From: Klaus Vink Slott <klaus@vink-slott.dk>
Organization: Hjemme
To: linux-kernel@vger.kernel.org
Subject: mixer hw loosing its settings during suspend
Date: Mon, 22 Jan 2007 21:47:19 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200701222147.19960.klaus@vink-slott.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I was discussing yesterday with Danny on his blok 
http://dkukawka.blogspot.com/2006/11/kpowersave-config-tutorial.html about  
how to restore sound on my old laptop. He told me that I should drop you a 
note as my problem in reality  should be handled by the kernel. 

Short story is that I have a old Dell X200 with a Intel sound controller. 
lspci says:
00:1f.5 Multimedia audio controller: Intel Corporation 82801CA/CAM AC'97 Audio 
Controller (rev 02)

After a suspend cycle sound is muted on all channels until the corresponding 
sliders hav been moved. 

For my purpose I saved a zero file (mixer setting all zero) and saved this 
as /etc/asound.zero. Then I made a /etc/pm/hooks/63sound script in pm-utils

#!/bin/bash
case $1 in
    hibernate|suspend)
        /usr/sbin/alsactl store
        /usr/sbin/alsactl -f /etc/asound.zero restore
        ;;
    thaw|resume)
        /usr/sbin/alsactl restore
        ;;
esac

This hack solves the problem on openSUSE 10.2. Feel free to ignore my letter 
as I guess most X200 is dead and gone by now - and my english is bad to :-)
--
Regards
Klaus
