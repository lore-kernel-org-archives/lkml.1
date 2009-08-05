Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbZHEAyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbZHEAyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZHEAyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:54:05 -0400
Received: from ru.mvista.com ([213.79.90.228]:47575 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753553AbZHEAyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:54:04 -0400
Date: Wed, 5 Aug 2009 04:54:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Device table matching for SPI subsystem
Message-ID: <20090805005404.GA14451@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
 <200908031916.02880.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200908031916.02880.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 07:16:02PM -0700, David Brownell wrote:
> On Wednesday 29 July 2009, Anton Vorontsov wrote:
> > 	platform_data is overkill for m25p80 chips, the
> > driver only needs to know exact chip model, and that's what device
> > tables are for.
> 
> To be fair, the platform_data also supports partitioning
> and labeling e.g. for cmdlinepart ...

With OF we do partitioning and labling via drivers/mtd/ofpart.c.

Though, so far there is no support for OF partitions in the m25p80
driver. I think we'd better put the OF partitions probing into
parse_mtd_partitions(), and avoid calling of_mtd_parse_partitons()
directly...

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
