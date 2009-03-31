Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZCaShs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZCaShs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZCaShj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:37:39 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:60063 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZCaShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:37:38 -0400
Message-ID: <49D262F5.6020700@mnementh.co.uk>
Date: Tue, 31 Mar 2009 19:37:41 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>	 <20090316193010.56644165@mjolnir.ossman.eu>	 <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>	 <49C84060.6010903@mnementh.co.uk>	 <aec7e5c30903250156v1eb38bd7qafe1c4236d9daef@mail.gmail.com> <aec7e5c30903301951g792a25a2s3abef57ba59fe8ee@mail.gmail.com>
In-Reply-To: <aec7e5c30903301951g792a25a2s3abef57ba59fe8ee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:

> Ping? Please let me know how you want me to rework the patches. Unless
> they are ok as-is. Any feedback on how to rewrite them would be
> greatly appreciated.

I replied to this earlier. Basically, investigate using the clk API. You 
should also try to work out how your board controls  clock / power to 
the socckets (if it can at all).

Like I said though, IIRC the clk API had shortcommings last time I 
looked which made it impossible to use on MFD devices (its tied to the 
CPU architecture, wheras the MFDs are platform independant. Dmitry did 
some work on this, but I dont recall how far he got.

Let me know if you come up with answers / solutions to these probelms. 
Until then, NAK - lets do it the right way, one time only. Not hack and 
bodge it repeatedly.

Sorry if that seems harsh, but I dont have time to review a hack thats 
going to end up replaced anyway when its done properly.

Best starting point would be to look up Dmitrys work on making the clk 
api CPU agnostic (if that hasnt already been merged). Then tmio-mmc can 
be modified to reqest a clock from its parent device (be that an MFD 
core or a platform device or whatever).

-Ian

-Ian
