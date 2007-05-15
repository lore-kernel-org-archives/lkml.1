Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbXEOIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbXEOIKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbXEOIKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:10:01 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47372 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760200AbXEOIJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:09:59 -0400
Date: Tue, 15 May 2007 10:08:19 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <a781481a0705142002g41312a03nc462fffd0a74310b@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705151006360.9570@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
  <4647569D.7010709@imap.cc>  <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
  <4648A3DF.7040004@imap.cc>  <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
  <4648D74C.6010305@imap.cc> <4648DE37.2080505@s5r6.in-berlin.de>
 <a781481a0705142002g41312a03nc462fffd0a74310b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15 2007 08:32, Satyam Sharma wrote:
> On 5/15/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Tilman Schmidt wrote:
>> > Am 14.05.2007 22:33 schrieb Jan Engelhardt:
>> > > * Disabling this menu disables all the fluff inside it,
>> 
>> except when it doesn't.

Blame CONFIG_EMBEDDED!

>> If menuconfig isn't used with strict discipline, we end up with
>> inconsistent and misleading presentation of the kernel configuration.
>
> Yes, this really requires discipline on the part of those who add new
> config options, to also "depends on" the menuconfig they're inside,
> otherwise we end up with inconsistencies. We can't really make this
> automatic, or can we?

Well more or less yes. Instead of adding 'depends on' on every subconfig
object, just wrap the whole thing into an if block:

	menuconfig FOOBAR

	if FOOBAR

	config FOO

	config BAR

	endif # FOOBAR

Since this is still edgy, an implicit if-endif block could be added as
part of the menuconfig. Sort of like the old menu:

	menuconfig FOOBAR

	config FOO

	config BAR

	endmenu

Robert P.J. Day had some solid ideas about this.


	Jan
-- 
