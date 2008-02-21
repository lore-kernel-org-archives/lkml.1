Return-Path: <linux-kernel-owner+w=401wt.eu-S1765860AbYBUL76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765860AbYBUL76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYBUL7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:59:50 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:37643 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbYBUL7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:59:50 -0500
Subject: Re: Apm_emulation and proper suspend
From: Richard Purdie <rpurdie@openedhand.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: rjw@sisk.pl, linux-main <linux-kernel@vger.kernel.org>
In-Reply-To: <20080221123318.41273a1f.Kristoffer.ericson@gmail.com>
References: <20080221123318.41273a1f.Kristoffer.ericson@gmail.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 11:59:45 +0000
Message-Id: <1203595185.9329.12.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 12:33 +0100, Kristoffer Ericson wrote:
> I'm reworking a couple of apm drivers and for whatever reason it
> doesn't seem to update my /proc/apm_bios. I was under the impression
> that it should do that when apm_bios was catted? Currently I have a
> value that never change. I export my get_power_status.. function
> properly but doesn't seem to touch it. I noticed that Richard had the
> extern int (void..apm_get_power) (...) declare an extra time (once in
> apm-emulation.h and another inside sharpsl.c), is that needed?

It should be removed from sharpsl.c in that case. The code was written
when the apm emulation code was arm specific and looked rather
different.

> Also, is apm the "brains" behind the suspend/resume interactions? By
> that I mean, should suspend be initiated through apm functions
> in order to be proper? I've tried to find examples but the best source
> of suspend related code is Richards code on sharp machines.

APM means you can can notify userspace of the suspend/resume events and
have some kind of interaction there through apmd. It gives a mechanism
where both userspace and kernel space can queue suspend requests and
where userspace can veto a voluntary suspend.

You can also suspend the system through "echo mem > /sys/power/state" in
userspace or calling pm_suspend() in kernel space but this doesn't give
anything else the opportunity to know about the event which is why we
still have apm.

Cheers,

Richard

