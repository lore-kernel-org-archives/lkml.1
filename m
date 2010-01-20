Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691Ab0ATO0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0ATO0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472Ab0ATO0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:26:08 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:44818 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0ATO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:26:08 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Wed, 20 Jan 2010 15:05:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001191025.37579.oliver@neukum.org> <201001192137.35232.rjw@sisk.pl>
In-Reply-To: <201001192137.35232.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001201505.41167.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Januar 2010 21:37:35 schrieb Rafael J. Wysocki:
> That said, Maxim reported that in his test case the mm subsystem apparently
> attempted to use I/O even if there was a plenty of free memory available and
> I'd like prevent that from happening.

Hi,

it seems to me that this is caused by the mm subsytem maintaing
a share of clean pages precisely so that GFP_NOIO will work.
Perhaps it is a good idea to
a) launder a number of pages if the system is about to be suspended
between the freezer and notifying drivers
b) set the ration of clean pages to dirty pages to 0 while suspending
the system.

	Regards
		Oliver
