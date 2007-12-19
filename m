Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXLSRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXLSRn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXLSRnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:43:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:65056 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXLSRnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dGBTw2Qa0JUbMkhEXEpS9YkUbjup0OS75enEpiiCgSgxyQVPhpBLNZn3y0XZWqqHNtivwq1e+92M/SVX0KORk+Va2sMv4yBv0iIknsYWI/7rkY1pnZg7vcJcNfYoMwIP528YM6Nzhj8SbB66hn+bqiDusdPAdMpLjGeeoxsBbmQ=
Message-ID: <83a51e120712190943m3bf0e2e4v2ea6b660142e9a5a@mail.gmail.com>
Date: Wed, 19 Dec 2007 12:43:13 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <47694FCC.1020507@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
	 <4768123A.7040603@cosmosbay.com>
	 <83a51e120712181144l65633b32r72cc369f9d012f47@mail.gmail.com>
	 <47682F8C.20205@cosmosbay.com>
	 <83a51e120712190853q33d9c7c1t4a46380665b7538b@mail.gmail.com>
	 <47694FCC.1020507@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> James Nichols a écrit :
> >> So you see outgoing SYN packets, but no SYN replies coming from the remote
> >> peer ?  (you mention ACKS, but the first packet received from the remote
> >>  peer should be a SYN+ACK),
> >
> > Right, I meant to say SYN+ACK.  I don't see them coming back.
>
> So... Really unlikely a linux problem, but ...
>


I don't know how you can be so sure.  Turning tcp_sack off instantly
resovles the problem and all connections are succesful.  I can't
imagine even the most far-fetched scenario where a router or every
single remote endpoints would suddenly stop causing the problem just
by removing a single TCP option.


> > I can take these captures and take a look at the results.
> > Unfortunately, I don't think I'll be able to make the captures
> > available to the general public.
>
> I dont understand, why dont you change IPs to mask them with 192.168.X.Y, or
> just ME, and peer1, peer2, peer...

I will see if I can do that, but it's major pain with 2000 hosts.
Plus, there is application data in the packets that I can't allow into
the public domain.  I really don't think I can pull it off... I
literally would have to go through our legal department.

>
> Random ideas :
>
> 1) Is your server behind a NET router or something ?

What's a NET router?  I am behind a Cisco router and a firewall, but
these network components have completely been replaced/rebuilt several
times in the 4+ years that we've had this problem.  I've looked at the
logs there and neither are doing anything other than passing the
traffic along.

> 2) Are you sure you are not using connection tracking, and hit a limit on it ?

I'm using ip_conntrack, but the limit I have for max entries is 65K.
The most I've seen in there are a couple thousand- that was one of the
first things I monitored very closely.
