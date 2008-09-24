Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYIXJhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYIXJhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYIXJhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:37:03 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:3531 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbYIXJhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:37:01 -0400
Date: Wed, 24 Sep 2008 18:35:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: hjk@linutronix.de, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: UIO device name
Message-ID: <20080924093551.GB7591@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>, hjk@linutronix.de,
	gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:21:33AM +0200, Joakim Tjernlund wrote:
> As far as I can see there isn't a way to name the /dev/uio%d device file
> to something more useful, is that so?
> I would like to name the device file from within the kernel so I can
> find the correct device from userspace.
> The very least is to control the minor(%d) number.
> 
You have a couple of options for this:

	- the 'name' sysfs entry for each of the uio devices, which
	  corresponds to the uio device name.
	- extracting the relevant data from things like 'lsuio'.
	- hooking in the pretty mame through udev to create an alias.

All of the information you need is available for userspace to play with,
and you want to be relying on the device name itself, not the minor
number (where you have no gaurantee of the ordering).

Documentation/DocBook/uio-howto.tmpl also has some more information on
what sort of information is exposed.
