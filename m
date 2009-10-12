Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZJLJhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZJLJhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZJLJhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:37:13 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:42805 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbZJLJhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:37:12 -0400
Date: Mon, 12 Oct 2009 11:35:16 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091012093516.GA4178@Pilar.aei.mpg.de>
References: <20091011162155.GA4260@Pilar.aei.mpg.de> <20091011180134.GA5197@core.coreip.homeip.net> <20091011193100.GA4410@Pilar.aei.mpg.de> <20091012090224.GB7403@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012090224.GB7403@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12.Oct'09 at  2:02:24 -0700, Dmitry Torokhov wrote:
> Carols, I see in the dmesg you supplied earlier ALPS was redetected
> successfully, so I guess the problem is that your synclient quirk did
> not run after resume. 

The basic touchpad stuff works after resume, it is only the right corner 
tap thing which stops working.

> The best way to handle it would be adding a HAL
> rule, something like this:
> 
> <?xml version="1.0" encoding="ISO-8859-1"?>
> <deviceinfo version="0.2">
>         <device>
>                 <match key="input.x11_driver" contains="synaptics">
>                         <merge key="input.x11_options.SHMConfig" type="string">On</merge>
>                 </match>
>         </device>
> </deviceinfo>

This is the scary and ugly thing which I was afraid of originally (it is 
off-topic here, but I don't like HAL). So I have this in my .bashrc 
 
synclient RTCornerButton=2

and so far it worked fine. If possible, I would like to keep it that
way. But I will test the HAL config above too.

> Still, I am curious to know why we can't simply reinitialize ALPS from
> the get go, could you please send me a dmesg of resume done with
> i8042.debug? Thanks!

Yes, I will do it.
