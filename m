Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZFULo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZFULo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZFULoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:44:19 -0400
Received: from alto.filmlight.ltd.uk ([77.107.81.250]:42681 "HELO
	a.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751112AbZFULoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:44:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2009 07:44:18 EDT
Message-ID: <B99511B1D2F847FD83D874D3A60B4DEA@BODDINGTON>
From: "Roger Willcocks" <roger@filmlight.ltd.uk>
To: "Deepak Vishwakarma" <vishwakarma.deepak@gmail.com>,
       <linux-kernel@vger.kernel.org>, <fuse-devel@lists.sourceforge.net>
References: <e31d15d70906192339w5074164bsef95ec097b467fcc@mail.gmail.com>
Subject: Re: [fuse-devel] Need Suggestions of packet overrun over 1 Gbps netwroktraffic in kernel 2.6.18
Date: Sun, 21 Jun 2009 12:37:35 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all,
>
> I have a high end server machine(multi core and large memory space) with 
> 10
> Gbps NIC. With linux kernel 2.6.18 it is giving packet overrun as traffic
> goes beyond 1.5 Gbps. I need suggestions in tuning kernel so that it can
> handle higher traffic rates.
>
> I have a 10 Gbps test bed to test the capability of server, equipped with
> 10Gigwsitches and traffic generated through multi 1Gig machines. I have
> tested server machine by gradually increasing the incoming traffic rate 
> and
> it's starting to do overrun as it crosses 1 Gbps.

I've seen a similar problem here with Myricom 10ge cards in multi-core 
machines running CentOS 5.2. A point-to-point connection configured as per 
http://www.myri.com/serve/cache/511.html worked fine (netperf > 9Gb/s) but 
introducing an HP 6400 switch gave 'dropped_link_overflow' errors on the 
receiving NIC, and the netperf figure dropped by about 90%.

The answer was to enable flow control on the switch. Interestingly an OSX 
XServe box could absorb the full bandwidth even with flow control disabled.

Obviously you shouldn't need hardware flow control with TCP traffic (and 
it's quite probably counter-productive) but the Myricom docs 
(http://www.myri.com/scs/download-Myri10GE.html) say that "The 10GbE switch 
to which the NICs are connected /must/ have flow control enabled", so that's 
what I'd look at first.

--
Roger

----------------------------
FilmLight's looking for an experienced kernel / systems developer (central 
London). An interest in parallel filesystems, image processing and low level 
scary magic would be an advantage; email me for more details.


