Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYAWXhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYAWXhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 18:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYAWXhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 18:37:41 -0500
Received: from smtp.digitalpath.net ([65.164.104.14]:59281 "EHLO
	smtp.digitalpath.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYAWXha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 18:37:30 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=digitalpath.net;
  b=tHqAuLU+QxXlmilhLfqPHaORTD6c4YbsreFMg0ExssoDQixGa+wnag8ODTKxbCTSPoZsnxi09duJY9Lgic5dE1TZpYLI8Lhkeq2Iz8rsDWtfhqcUMzY+PQJh1O5Ui1oG  ;
Message-ID: <2414.65.164.104.9.1201131449.squirrel@webmail.digitalpath.net>
Date: Wed, 23 Jan 2008 15:37:29 -0800 (PST)
Subject: Write to MFGPT_NR_MSR causes immediate hard reset
From: "Hasan Rashid" <hasan@digitalpath.net>
To: linux-kernel@vger.kernel.org
Reply-To: hasan@digitalpath.net
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I back ported the CS5536 MFGPT based watchdog timer from Kernel 2.6 to
Kernel 2.4 (I have to). I am using the Alix2c0 board with TinyBios v0.99.
I have been following the discussion on this thread “Re: 2.6.24-rc8 hangs
at mfgpt-timer". I disabled the MFGPT workaround in the BIOS and it seems
to load the module just fine (no more hangs). I get this when I load
geode-mfgpt.o:

################
Found vendor: 0x1022h, device: 0x2090h
reading from: 6206 reading from: 620e reading from: 6216 reading from:
621e reading from: 6226 reading from: 622e reading from: 6236 reading
from: 623e
geode-mfgpt:  8 timers available.

And when I load the watchdog module geodewdt.o:

geode-mfgpt:  Registered timer 0
written to: 6206 -- just something I am doing to verify the write
operation written to: 6202

Everything seems to be fine except when I try to setup a bit in
MFGPT_NR_MSR that allows MFGPT0_CMP2 to perform a hard reset when the
event fires, it resets it right away.

/* Set up comparator 2 to reset when the event fires */
//	geode_mfgpt_set_event(wdt_timer, MFGPT_CMP2, MFGPT_EVENT_RESET);

I am not sure if the Clock Switch section 5.16.3 in the CS5536 data book,
pointed by Willy Tarreau in one of his posts, is related to it. When the
API module is loaded, it only executes read instructions on the
MFGPT_REG_SETUP registers. Can anyone speculate as to why the board resets
as soon as the watchdog timer module executes the geode_mfgpt_set_event
function? Basically when this function is called, (0x100000)h is written
to the MFGPT_NR_MSR register.

TIA.

Regards,
Hasan Rashid
Embedded Systems Software Engineer


