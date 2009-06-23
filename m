Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZFWQwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZFWQwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759278AbZFWQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:52:36 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:44742 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756063AbZFWQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:52:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cA9msAjOc+bGWCJke3sMOXR9SFRRGlgvRkm/d+NNHL+6uxol0j4OR9Up268ZjtJVVL6ybhdf22ak2R01Hf7h+C2XkbxvLkd4W+7vEBXgoetKG0N6LaM0LJcWrFZcv03eZptHBA0hL41HU++Bgfb9pDTraocEBfqJMCN8qfMgNbM=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: oisKjl0VM1kshgSdeH6jilufS7th.xvwH42npwO2dVZLZNhQ8db5gt1jRi42ncLYdm3QxDltYcV3C0bumsb9P5hCeyzlv8T8_d_OCpvzjvMk5YMTLn4XageJDs6FwByZelnZJ876nfBQ_hTobeCf1usmXV_VJUCqhfL1NipJgsP93lwHlNGDlcEBShm2pQGqhMPvulQSc1Po.TFpeUPU8rPZiiuE12bT8uwIagIux_e7hRQ5cAQgUI4Q2J6fOlROmIqyApbP3YH.GY7B
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Tue, 23 Jun 2009 09:52:37 -0700
User-Agent: KMail/1.9.10
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <200906230022.39040.david-b@pacbell.net> <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
In-Reply-To: <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906230952.37592.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Marek Szyprowski wrote:
> /* low_latency means ldiscs work in tasklet context, without
>  * needing a workqueue schedule ... easier to keep up.
>  */
> 
> So in low latency mode calls are made from a tasklet.

... and that has, at some point since 2.6.26 or so, become a
problem that caused oopsing.


> This is not true in 
> my case, as the S3C OTG UDC driver does all its job in interrupts. This
> way also a (usb) packet_done callback is done from an interrupt. I expect
> that g_serial driver interacts with tty layer in that packet_done callback,
> so this is the source of the problems. I noticed that some other UDC
> drivers also does all its job from an interrupt, so they also might be
> affected. How this bug should be properly resolved?

Change the u_serial.c code so that this newish tty behavior
stops causing problems:  don't set low_latency.

But also try and sort through any consequences of that, and
don't forget to update the comments which talk about how the
low_latency setting is affecting code flow.

- Dave
