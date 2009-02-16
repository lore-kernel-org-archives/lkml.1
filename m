Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZBPPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZBPPin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZBPPif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:38:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:57961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZBPPie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:38:34 -0500
Date: Mon, 16 Feb 2009 07:38:10 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff\, Richard" <r-woodruff2@ti.com>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216073810.200be4a6@infradead.org>
In-Reply-To: <adad4di7vef.fsf@cisco.com>
References: <200902160010.16955.rjw@sisk.pl>
	<20090215164456.34aef7e8@infradead.org>
	<adad4di7vef.fsf@cisco.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009 22:23:04 -0800
Roland Dreier <rdreier@cisco.com> wrote:

>  > > (2) put given subset of devices into low power states whenever
>  > > they are not used, without putting the entire system into a
>  > > sleep state.
> 
>  > For (2), for me the answer is very obvious:
> 
>  > The Device Driver needs to make the decision to put the device to
>  > sleep. There are no ifs and buts about this.
> 
> For PC-like systems this is probably all that needs to be said.
> However for highly integrated SoC systems (as Android is obviously
> targeting) there is another level of complexity due to the
> interdependency among various devices... eg things like if I know the
> SD controller and the wifi chip are both asleep then I can put my
> SDIO controller to sleep; and if the SDIO controller and the NAND
> controller are both asleep then I can stop clock X and save more
> power; etc etc.

This does not change the rules.
The individual drivers still make up the decision of what state their
own block should be in.

What you're talking about is coordination. Some systems do this in
silicon, and others, like you mention, need a small software layer to
do this coordination. Fine. But this doesn't change the fundamentals.

> 
> This is what the PowerOp/DPM work was all about.  Unfortunately that
> doesn't seem to have made much progress upstream. 

PowerOP/DPM were... more or less hampered because they operated in
global "modes". Everyone (including the OMAP guys) has pretty much gone
away from the idea that modes are global. Power management is not
global; if you treat it as global then you're in trouble, since the
decisions really are local (and in better hw, even done in the hw)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
