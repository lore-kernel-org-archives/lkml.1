Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYCAW6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYCAW6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 17:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYCAW6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 17:58:15 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:27119 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755012AbYCAW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 17:58:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XZ7/3thsJHwdsrKlS2VWZOy8F9iKcG3ahkMKdMzOQsG2rw/Hgt9aQYWmkOC5b9yq+Ophdhw2Hjl1sgaNyRTxaWVAzc00ZTvjKk0XQ7A21ftsQU36n/mATB90xFKlTjvBL84ScQGUzno7SSNaTiONO7KQkym7vLP5UWk7eLGLW5g=  ;
X-YMail-OSG: gTL6DpsVM1kBzd3zG_YcGu9Oyw_j6n2lbxidA49YXnEZc9J1gvQ1elWfI8fAiqzzX4p0q4MOon9Mh1odPpYXhjhXzfZSQeZgdSJXZGEXfJRYtbEDdg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bosko Radivojevic <bosko.radivojevic@gmail.com>
Subject: Re: High resolution timers on AT91SAM926x
Date: Sat, 1 Mar 2008 14:57:40 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803011457.40857.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a way to enable high resolution timers on AT91SAM926x?

Update PIT to support the clocksource/clockevent framework:
  http://marc.info/?l=linux-arm-kernel&m=119940724711435&w=2

Declare timer/counter block platform devices:
  http://marc.info/?l=linux-arm-kernel&m=120302318811110&w=2

Use timer/counter blocks for better clocksource and clockevents:
  http://marc.info/?l=linux-kernel&m=120373043520279&w=2
  http://marc.info/?l=linux-kernel&m=120373063320487&w=2

The focus in that last patch is on NO_HZ support -- so the
clockevents run at 32 KiHz (about 31 usec precision for HRT)
to allow overall HZ to run below 1 where practical.   If you
need even higher precision, you could update that clockevent
code to use a different base clock.

Those last two patches are in some MM tree, and Haavard has
some updates to then (which don't much affect functionality).

I understand the upcoming 2.6.24-at91 patch will include the
first two patches.

- Dave
