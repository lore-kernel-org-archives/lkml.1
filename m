Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZDFKSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZDFKSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 06:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZDFKSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 06:18:23 -0400
Received: from bu3sch.de ([62.75.166.246]:44801 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZDFKSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:18:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: ath9k becon loss messages
Date: Mon, 6 Apr 2009 12:17:30 +0200
User-Agent: KMail/1.9.9
Cc: Kalle Valo <kalle.valo@iki.fi>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1238923439.4120.9.camel@localhost.localdomain> <87bprbif2f.fsf@litku.valot.fi> <200904060914.32245.helmut.schaa@gmail.com>
In-Reply-To: <200904060914.32245.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061217.31134.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009 09:14:31 Helmut Schaa wrote:
> Am Sonntag, 5. April 2009 schrieb Kalle Valo:
> > Jaswinder Singh Rajput <jaswinder@kernel.org> writes:
> > 
> > >> And besides that, I think one can easily remotely trigger this
> > >> message and flood the logs. So it should probably _also_ be
> > >> ratelimited.
> > >
> > > normally it prints after 120 seconds:
> > >
> > > [ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > > [ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> 
> > Then there is something happening in ath9k or your AP which prevents
> > ath9k from receiving beacons. Try pinging your AP with 100 ms
> > interval. Do you see anything happening in 120 s intervals?
> 
> NetworkManager typically scans every 120 seconds and I can also trigger
> the messages by a manual scan with iwlist. I did not dig any further but
> the messages seem to appear right at the end of the scan. Tried with iwlagn
> and both sw_scan and hw_scan.

Yeah OK. While scanning it's expected to lose some frames.

However, the driver should probably protect against this by using the scan notification
callbacks. It could disable beacon-loss reporting while scanning.

-- 
Greetings, Michael.
