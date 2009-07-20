Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZGTV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZGTV31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZGTV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:29:26 -0400
Received: from mail.crca.org.au ([67.207.131.56]:39900 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZGTV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:29:26 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4A64E1D6.8090102@crca.org.au>
Date: Tue, 21 Jul 2009 07:29:58 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] hibernate / memory hotplug: always use	for_each_populated_zone()
References: <1248103551.23961.0.camel@localhost.localdomain>
In-Reply-To: <1248103551.23961.0.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Gerald Schaefer wrote:
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> Use for_each_populated_zone() instead of for_each_zone() in hibernation
> code. This fixes a bug on s390, where we allow both config options
> HIBERNATION and MEMORY_HOTPLUG, so that we also have a ZONE_MOVABLE
> here. We only allow hibernation if no memory hotplug operation was
> performed, so in fact both features can only be used exclusively, but
> this way we don't need 2 differently configured (distribution) kernels.
> 
> If we have an unpopulated ZONE_MOVABLE, we allow hibernation but run
> into a BUG_ON() in memory_bm_test/set/clear_bit() because hibernation
> code iterates through all zones, not only the populated zones, in
> several places. For example, swsusp_free() does for_each_zone() and
> then checks for pfn_valid(), which is true even if the zone is not
> populated, resulting in a BUG_ON() later because the pfn cannot be
> found in the memory bitmap.

I agree with your logic and patch, but doesn't this also imply that the
s390 implementation pfn_valid should be changed to return false for
those pages?

Regards,

Nigel
