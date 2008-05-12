Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbYELUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbYELUSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYELUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:18:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:49601 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753703AbYELUSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:18:46 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX19YBV18Uw9YpUQsKzVj0SroOlwo8T712Y1UaYTEca
	pnyB6K8DmIrOi3
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump firmware build error fix
Date: Mon, 12 May 2008 22:18:15 +0200
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
References: <20080512101231.GA11755@elte.hu> <200805121930.10909@orion.escape-edv.de> <20080512194630.GA10174@linuxtv.org>
In-Reply-To: <20080512194630.GA10174@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805122218.15887@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach wrote:
> On Mon, May 12, 2008 at 07:30:10PM +0200, Oliver Endriss wrote:
> > Ingo Molnar wrote:
> >> -     depends on DVB_AV7110 && !STANDALONE
> >> +     depends on DVB_AV7110 && !STANDALONE && !PREVENT_FIRMWARE_BUILD
> 
> > If you set DVB_AV7110_FIRMWARE=y, the firmware file under
> > DVB_AV7110_FIRMWARE_FILE must exist...
> 
> The point of PREVENT_FIRMWARE_BUILD is to make build testing
> with "make randconfig" possible. I think you should ACK
> this patch, it doesn't have any downsides for users of
> this driver.

No. If randconfig deselects both STANDALONE and PREVENT_FIRMWARE_BUILD,
the same problem will happen again...

The problem is that randconfig does not know what to do (i.e. provide a
firmware file) when it selects DVB_AV7110_FIRMWARE=y.

The driver depends on STANDALONE, and that should be sufficient:
| CONFIG_STANDALONE:
|   Select this option if you don't have magic firmware for drivers that
|   need it.

while CONFIG_PREVENT_FIRMWARE_BUILD means:
| CONFIG_PREVENT_FIRMWARE_BUILD:
|   Say yes to avoid building firmware. Firmware is usually shipped
|   with the driver, and only when updating the firmware a rebuild
|   should be made.

Imho randconfig should always set STANDALONE=y.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
