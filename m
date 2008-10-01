Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYJANxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYJANxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYJANxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 09:53:13 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:51000 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYJANxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 09:53:13 -0400
From: Frans Pop <elendil@planet.nl>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: CD tray closes spontaneously after opening it
Date: Wed, 1 Oct 2008 15:53:04 +0200
User-Agent: KMail/1.9.9
Cc: "Tony Vroon" <tony@vroon.org>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
References: <200809301247.05367.elendil@planet.nl> <200809302150.38872.elendil@planet.nl> <ac3eb2510809301302l7d966896tfb0e3d230598974@mail.gmail.com>
In-Reply-To: <ac3eb2510809301302l7d966896tfb0e3d230598974@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011553.05318.elendil@planet.nl>
X-OriginalArrivalTime: 01 Oct 2008 13:53:09.0945 (UTC) FILETIME=[09FA8290:01C923CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008, Kay Sievers wrote:
> >> Does this also happen when you set:
> >>   /proc/sys/dev/cdrom/autoclose
> >> to 0?
> >
> > I'll set that on boot using /etc/sysctl.conf and will report if I can
> > still reproduce with that setting. I've checked that the "normal"
> > value is 1.
>
> That will prevent the closing, when something tries to open the device
> in blocking mode. If that solves the issue, you should start looking
> which process tries to access your drive.

Right. It happens with autoclose=0 too.

Any suggestions for the next step? Maybe add some instrumentation in the 
cdrom or ide-cd drivers?

I think I'll also go back to 2.6.26 for a while to see if I can reproduce 
it with that. I'm fairly sure it won't, but confirming that will be a 
good data point.

I don't see myself bisecting this as long as I don't have a reliable way 
to reproduce it.

BTW, I have considered a hardware problem like a short in the eject 
button, but I don't think that's it. The eject button "feels" good and 
I'd expect it to also spontaneously eject if that was the problem.
It also does feel like there is a pattern to it, even if I cannot see yet 
what that pattern would be.
