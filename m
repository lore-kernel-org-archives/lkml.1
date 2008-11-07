Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYKGSoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYKGSoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYKGSnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:43:47 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:55301 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYKGSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gc6gka0YheemZ8sn8d9qVfpxkI+OVC0vcoOEXEB7iZAuPkK0c4pFqmgtALa5OB+z3h
         p20tJ+ivqE2/AWVuWIr6t9G1HFKvbgwlmb4hGN4wzLKZpgWA0qAMaaBJJds3uT7smUWS
         LaRT/zk8y0+VS8HvQVC0b/B8iwySuJUxZNx64=
Message-ID: <1e41a3230811071038p58a55cc6g9103b891ca15a1df@mail.gmail.com>
Date: Fri, 7 Nov 2008 10:38:26 -0800
From: "John Heffner" <johnwheffner@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: time for TCP ECN defaulting to on?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Dave Hudson" <linux-kernel@blueteddy.net>,
       "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       "Mikael Abrahamsson" <swmike@swm.pp.se>,
       "David Miller" <davem@davemloft.net>, daniel.blueman@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org
In-Reply-To: <491454A3.1040802@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	 <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
	 <20081105.151015.206163697.davem@davemloft.net>
	 <alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
	 <Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
	 <4914240F.7050701@blueteddy.net>
	 <20081107142950.13906925@lxorguk.ukuu.org.uk>
	 <491454A3.1040802@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IETF has provided a spec, and additional documents on deployment
issues.  They have provided all the guidance they are going to.  It's
now up to implementers to weigh the trade-offs.

My own observations and opinions, for what they're worth:

Turning on ECN doesn't hurt as much as it used to.  Back in the early
'00s, there were a lot of devices sold especially to financial
institutions to "protect" their web sites.  These devices dropped any
packets with (previously) reserved header bits set, because some
people used these as a covert information channel.  I believe these
devices are not as common as they once were, but there are still a few
big sites that black hole these packets.  (I know that southwest.com
is still an offender.)

I have not actually heard of any issues with consumer-grade stuff, but
that may be because ECN has been disabled by default for so long.

Almost no network operators turn on ECN marking in their routers.  In
fact, almost none care to do any sort of AQM.  The practical benefits
of ECN are still somewhat unclear for most people.  For example, it
can help with latency-sensitive applications, but mostly requires a
big queue to work well, so doesn't help as much as you would hope.
There are some interesting ideas on how to better use ECN information,
but these are mostly still research.

ECN black hole detection is pretty simple, and I don't see much reason
not to do it.

  -John


On Fri, Nov 7, 2008 at 6:45 AM, David Newall <davidn@davidnewall.com> wrote:
> Isn't this a question for the IETF to answer?  Are they saying turn on
> ECN now?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
