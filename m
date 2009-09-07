Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZIGWoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZIGWoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZIGWoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:44:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51072 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbZIGWoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:44:02 -0400
X-Sasl-enc: GFLPczwFFwSH3cODK4cbx8IXEBSLPcUfTmu67FxoWOtD 1252363444
Date: Mon, 7 Sep 2009 19:43:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, astarikovskiy@suse.de, lenb@kernel.org,
       linux-acpi@vger.kernel.org, rjwysocki@sisk.pl
Subject: Re: [PATCH] Fix ACPI's EC regression from 2.6.29: use usleep()
 instead of msleep()
Message-ID: <20090907224359.GI16533@khazad-dum.debian.net>
References: <20090907211423.GA2535@bizet.domek.prywatny>
 <20090907215712.GH16533@khazad-dum.debian.net>
 <20090907220413.GA2593@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907220413.GA2593@bizet.domek.prywatny>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Sep 2009, Karol Lewandowski wrote:
> > On Mon, 07 Sep 2009, Karol Lewandowski wrote:
> > > Following patch reverts commit that changed usleep() to mleep()
> > > in ACPI's EC driver. That change made hotkeys on my Thinkpad T21
> > > unusable after resume.
> > 
> > Karol, can you send us the dmidecode information for your thinkpad?
> 
> Sure, here goes dmidecode output with UUID and SN grayed out (I guess
> that isn't needed).

Thank you, and yes, it is a good idea to gray out the UUID and SN, we don't
need or want them.

Can you please send the output of recent acpidump to me by private email?
You are using the latest T21 BIOS, and a full ACPI dump can be quite
valuable for my work in thinkpad-acpi.

I think the best way to go about this, as long as we don't get reports from
many other boxes failing to resume or hitting ACPI EC problems, is to add a
"slow_thinkpad_ec" quirk, and use dmi matches to enable it on the T21 and
other thinkpads of that vintage (definately all of the T2x and A2x, maybe a
few others.  I have a candidate list here that I assembled for other
reasons.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
