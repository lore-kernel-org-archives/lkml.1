Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0BBOgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:36:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50136 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595Ab0BBOgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:36:01 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <d82e647a1002020536q778a9339na9abb57c3d71ccf4@mail.gmail.com>
References: <20100129185434.GH19501@one-eyed-alien.net>
	 <201002021248.10994.oliver@neukum.org>
	 <1265112072.12634.53.camel@pc1117.cambridge.arm.com>
	 <201002021307.56991.oliver@neukum.org>
	 <1265114375.12634.61.camel@pc1117.cambridge.arm.com>
	 <d82e647a1002020536q778a9339na9abb57c3d71ccf4@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 14:35:48 +0000
Message-Id: <1265121348.12634.76.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 14:35:50.0027 (UTC) FILETIME=[03E7C5B0:01CAA415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:36 +0000, Ming Lei wrote:
> 2010/2/2 Catalin Marinas <catalin.marinas@arm.com>:
> 
> > In the iSCSI case, does the HCD driver write directly to a page cache
> > page? Or it just fills in network packets that are copied to page cache
> > pages by the iSCSI code (sorry, I'm not familiar with this part of the
> > kernel). If the latter, the cache flushing in the HCD driver would not
> > help and it needs to be done in the iSCSI code.
> 
> So we should flush dcache page in the place where the user mapped
> page is copied to, instead of low level driver which does not do such
> thing always.

Or both if you can't be sure whether the driver copies directly to a
page cache page.

-- 
Catalin

