Return-Path: <linux-kernel-owner+w=401wt.eu-S936495AbXLTQh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936495AbXLTQh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763596AbXLTQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:37:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:27446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761550AbXLTQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:37:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q2SUCVu7B6ePotUvKBXSKJsZgyEF7WcM5931dhpdxoyl7DqyaYnk1cP+rCsBBM1XjuESeNOruLO7mNtVyM1IT6azBB7Y3KhGWNyxcb9nkebP12FegJVnRH3s90FrWMVlyNxJqX6rjhM2BiIX/OYhCVchY8g8GwJ9hjr9m5tzy6o=
Message-ID: <83a51e120712200837p9e3d1a4g15b5f4763597073e@mail.gmail.com>
Date: Thu, 20 Dec 2007 11:37:39 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Glen Turner" <gdt@gdt.id.au>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Eric Dumazet" <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <1198161695.6154.47.camel@andromache>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
	 <4768123A.7040603@cosmosbay.com>
	 <83a51e120712181144l65633b32r72cc369f9d012f47@mail.gmail.com>
	 <47682F8C.20205@cosmosbay.com>
	 <83a51e120712190853q33d9c7c1t4a46380665b7538b@mail.gmail.com>
	 <47694FCC.1020507@cosmosbay.com>
	 <83a51e120712190943m3bf0e2e4v2ea6b660142e9a5a@mail.gmail.com>
	 <Pine.LNX.4.64.0712191857270.12329@fbirervta.pbzchgretzou.qr>
	 <1198161695.6154.47.camel@andromache>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I'd be very surprised if the router is acting as anything more
> that a network-layer device. It might perhaps have some soft connection
> state being used for generating accounting records.  Being Cisco
> it's probably a switch-router, so it might carry some per-port hard
> state for validating source IP addresses and ARPs on each port.
>
> The firewall is much more likely to be carrying per-flow Sack
> state. The Cisco PIX had a bug with SACK handling (CSCse14419,
> fixed in 7.0(7), 7.1(2.34), 7.2(2.2), 8.0(0.141) but perhaps it
> has regressed). A simple trace either side of the firewall will
> show the inconsistency between the TCP sequence number (which
> gets randomised) and the Sack sequence number (which didn't).
> You could disable the TCP Sequence Number Randomisation feature
> and see if the fault reoccurs.

I do have TCP Sequence # Randomization enabled on my router.  However,
if this was causing an issue, wouldn't it always occur and cause
connection issues, not just after 38 hours of correct operation?  I
can look into turning this off, but I'll likely have to jump through
several hoops which will be challenging if I don't have a very clear
definitive reason why this is causing this issue.  Plus, I've had this
problem with at least 2 other sets of network switches over the past 4
years.  I'm actually running 7.0(6), which doesn't have the fix you
mentioned.  If it really is possible that this issue wouldn't always
cause problems, but only after hours of succesful operation, then I
could probably motivate the upgrade.  I can try to setup a trace, but
this is a lot of work for other people in my organization, so it will
take quite some time.


> You'd probably should also investigate the Linux kernel,
> especially the size and locks of the components of the Sack data
> structures and what happens to those data structures after Sack is
> disabled (presumably the Sack data structure is in some unhappy
> circumstance, and disabling Sack allows the data to be discarded,
> magically unclaging the box).
>
> In the absence of the reporter wanting to dump the kernel's
> core, how about a patch to print the Sack datastructure when
> the command to disable Sack is received by the kernel?
> Maybe just print the last 16b of the IP address?

Given the fact that I've had this problem for so long, over a variety
of networking hardware vendors and colo-facilities, this really sounds
good to me.  It will be challenging for me to justify a kernel core
dump, but a simple patch to dump the Sack data would be do-able.
