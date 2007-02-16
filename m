Return-Path: <linux-kernel-owner+w=401wt.eu-S1422722AbXBPAzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422722AbXBPAzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422858AbXBPAzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:55:18 -0500
Received: from mail.queued.net ([207.210.101.209]:1372 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422722AbXBPAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:55:17 -0500
Message-ID: <45D50101.60802@debian.org>
Date: Thu, 15 Feb 2007 19:55:29 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [patch 1/3] Input: psmouse - create PS/2 protocol options for
 Kconfig
References: <45D43115.6060806@debian.org> <20070215164553.28f3f9af.akpm@linux-foundation.org>
In-Reply-To: <20070215164553.28f3f9af.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 05:08:21 -0500
> Andres Salomon <dilinger@debian.org> wrote:
> 
>> Initial framework for disabling PS/2 protocol extensions.  The current
>> protocols can only be disabled if CONFIG_EMBEDDED is selected.  No
>> source files are changed, merely build stuff.
> 
> ugleee.  What benefit do we get for all this additional maintenance burden?

On any platform where you know exactly what ps/2 device you'll have
plugged in, you can cut the size of psmouse.ko in half by disabling
protocol extensions that are not in use.

For future protocol extension additions, we can add them without making
the psmouse driver even larger.  We have one queued up for OLPC's
touchpad which we'd like to get included in mainline, and it was made
clear that being able to disable protocol extensions was a prerequisite
for getting it included.  The OLPC ps/2 protocol extension would be
disabled unless CONFIG_EMBEDDED and CONFIG_MOUSE_PS2_OLPC were both enabled.

See http://lkml.org/lkml/2006/9/11/200
