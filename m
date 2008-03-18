Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYCRMs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYCRMs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYCRMst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:48:49 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:33988 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbYCRMss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:48:48 -0400
Date: Tue, 18 Mar 2008 13:47:59 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MMC: Card detection through pin CD/DAT3 issue
Message-ID: <20080318134759.04450604@mjolnir.drzeus.cx>
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4DF@zuerich.BC-Int.NET>
References: <83116F0A4FF67A4F97BA0B6E408C48E301DAB4AA@zuerich.BC-Int.NET>
	<20080318122033.020b45b5@mjolnir.drzeus.cx>
	<83116F0A4FF67A4F97BA0B6E408C48E301DAB4DF@zuerich.BC-Int.NET>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 13:24:33 +0100
"Wappler Marcel" <Marcel.Wappler@bridgeco.net> wrote:

> 
> I have found this requirement in the SD host controller spec:
> "The card detect is active regardless of the SD Bus Power."
> 
> I wonder how the card should be able to pull up the CD/DAT3 Pad to VCC
> if its only VCC pad is not connected to VCC due to the fact that the host
> controller has switched off the cards power - any idea how this could be
> managed?

It could provide a very low voltage and current, just enough to probe the resistor but not enough to actually power anything on the card.

> 
> There is a SD card spec section somewhere which statet that:
> "If one of the supply pins (VDD or VSS) is not connected properly, then
> the current is drawn through a data line to supply the card."
> 
> Maybe this is the key in understanding ho the pull up without VCC connected
> works?
> 

I think that's just a warning that the supply pins need to be grounded when power is disabled. I have a controller where they are left floating, and some cards do indeed power up using power from the data line pull-ups. The end results is a heavily malfunctioning card due to insufficient power supply.

Most of this card detection using DAT3 business is unknown to me. The spec that describes how it is supposed to work is not publicly available, so I can only speculate.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
