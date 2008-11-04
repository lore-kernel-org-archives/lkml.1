Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYKDWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYKDWhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYKDWg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:36:56 -0500
Received: from vena.lwn.net ([206.168.112.25]:58145 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbYKDWgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:36:55 -0500
Date: Tue, 4 Nov 2008 15:36:53 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Keith Packard <keithp@keithp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] IO mappings, #2
Message-ID: <20081104153653.4b785480@bike.lwn.net>
In-Reply-To: <20081103172951.GA7929@elte.hu>
References: <20081022093615.GF12453@elte.hu>
	<1224746087-13991-1-git-send-email-keithp@keithp.com>
	<20081023080553.GB14714@elte.hu>
	<1224776350.6738.14.camel@koto.keithp.com>
	<21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com>
	<alpine.LFD.2.00.0811030833340.3459@nehalem.linux-foundation.org>
	<20081103165319.GA27433@elte.hu>
	<20081103172951.GA7929@elte.hu>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having looked at this some, I have one, tiny little suggestion:

> +With this mapping object, individual pages can be mapped either
> atomically +or not, depending on the necessary scheduling
> environment. Of course, atomic +maps are more efficient:
> +
> +	void *io_mapping_map_atomic_wc(struct io_mapping *mapping,
> +				       unsigned long offset)

Should the documentation for this function (perhaps the
certainly-forthcoming kerneldoc comments :) mention loudly that this
function uses KM_USER0?  This isn't kmap(), and doesn't look much like
it; someday some developer might get an ugly surprise when they try to
use that slot simultaneously for something else.

jon
