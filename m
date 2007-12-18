Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbXLRTpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbXLRTpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 14:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLRTpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 14:45:16 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:31418 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750700AbXLRTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 14:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rW6qNBXlkttg2xTNK66F7/Ai/nG2GIt8gg9LWYUvFXXvqJziinGka09GUEZroJU0TXOvap3dnfFgDulySgIQ1SNcBK1Wa7EX7vdyX5RI6vsqSAF6REWtzHTPmmbXCtYRHxZ4LBBtD5sQSeRWw9xCmAuuhFaY+jnnyIyvA/Jl7Qg=
Message-ID: <83a51e120712181145l75a19e72o3194676b05a855a6@mail.gmail.com>
Date: Tue, 18 Dec 2007 14:45:13 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
In-Reply-To: <4768123A.7040603@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com>
	 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com>
	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
	 <4768123A.7040603@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well... please dont start a flame war :(
>
> Back to your SYN_SENT problem, I suppose the remote IP is known, so you
> probably could post here the result of a tcdpump ?
>
> tcpdump -p -n -s 1600 host IP_of_problematic_peer -c 500
>
> Most probably remote peer received too many attempts from you, and a
> anti DOS mechanism is droping all SYN packets.
>
> Ah well... I remember now that you mentioned tcp_sack setting had an
> effect, so forget the "Most probably..." and give some tcpdump traces :)


I'm not trying to start a flame war.  My situation is that I'm a
performance engineer and I have to restart the app every 38 hours due
to this issue, I'm not the person(s) who wrote it.  It's my job (and
the kernel's) job to support whatever application is being run.  Also,
I was seriously curious to know if there were any better tools for
debugging this in C that I wasn't aware of.  Anwyay...


I've run tcpdump for all IPs during this problem.  I haven't tried
doing it for a single explicit IP address- due to the nature of the
workload it's very difficult to know which IPs will be hit at any
given moment.   What I did see in the full IP captures is that the
returning ACKs don't show up in the packet capture.  Unfortunately,
tcpdump reported that some packets were dropped during the capture.
Is it possible that the kernel was dropping the packets before they
could be captured by tcpdump?

Also, I have some doubts about it being the end points or an
intermediate router, please let me know if these are unreasonable:
1)  We've completely replaced our routing equipment several times in
the past 4 years... totally different colos, router vendors, firewall
vendors, firewall rules, etc.
2)  It occurs across all remote end points at the exact same time.
The endpoints are hetrogenous, run brain-dead OS's that don't do any
DOS detection, reboot at random times of the day, are geographically
distributed, are on different ISPs, etc. etc.
3)  Turning of tcp_sack instantaneously makes the problem go away.  If
it were endpoints or a router, it seems like a stretch that removing a
single TCP option would make the problem instantly resolve itself in
so many places other than the originating host.
