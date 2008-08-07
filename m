Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYHGSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYHGSXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbYHGSWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:22:38 -0400
Received: from lap75545.ornl.gov ([160.91.210.54]:36112 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbYHGSWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:22:37 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218130475.14483.16.camel@jaswinder.satnam>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Aug 2008 14:21:28 -0400
Message-Id: <1218133288.18118.20.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-07 at 23:04 +0530, Jaswinder Singh wrote:
> Hello David Dillow,
> 
> On Thu, 2008-08-07 at 13:30 -0400, David Dillow wrote:
> > On Thu, 2008-08-07 at 22:26 +0530, Jaswinder Singh wrote:
> > >       firmware: avoiding multiple replication for same firmware file
> > 
> > If this is the last patch you sent to the list, I think there are still
> > locking bugs in it. I was short on time, so I didn't give it a full
> > review, but I remember seeing problems. I'll try to give it some time
> > tonight, if Andrew doesn't beat me to it.
> 
> This is updated and revised patch.

I just looked at the tree; it still has locking issues, and needs
further review. You must protect the list from modification while you
iterate it looking for an match on the requested firmware. Also, was it
legal to call release_firmware() from an atomic context? It can now
sleep, which may be an issue...

Also, should any two drivers share the same firmware,
release_firmware_all() could leave one of them without its firmware, but
I'm not sure if that is an issue either.

> > >       typhoon: use request_firmware
> > 
> > This is untested -- again, no time over the weekend -- and I'd rather
> > not have it go upstream until has been verified.
>
> ﻿This is also updated and revised patch.

Please drop that patch from the series for now; I'm not happy with it,
as it reintroduces things I've asked be changed. If you get the core
firmware_class issues fixed up, I'll respin what I had.

Dave
