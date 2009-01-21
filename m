Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbZAUP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbZAUP7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZAUP7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:59:44 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55255 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZAUP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:59:44 -0500
Date: Wed, 21 Jan 2009 16:59:41 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: check bus->match without holding device
 lock(v2)
Message-ID: <20090121165941.00428154@gondolin>
In-Reply-To: <1232551667-4829-1-git-send-email-tom.leiming@gmail.com>
References: <1232551667-4829-1-git-send-email-tom.leiming@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 23:27:47 +0800,
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch moves bus->match out from driver_probe_device and
> does not hold device lock to check the match between a device
> and a driver.
> 
> The idea has been verified by the commit 6cd495860901,
> which leads to a faster boot. But the commit 6cd495860901 has
> the following drawbacks: 1),only does the quick check in
> the path of __driver_attach->driver_probe_device, not in other
> paths; 2),for a matched device and driver, check the same match
> twice. It is a waste of cpu ,especially for some drivers with long
> device id table (eg. usb-storage driver).
> 
> This patch adds a helper of driver_match_device to check the match
> in all paths, and testes the match only once.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/base/base.h |    5 +++++
>  drivers/base/bus.c  |    2 +-
>  drivers/base/dd.c   |   19 +++++++------------
>  3 files changed, 13 insertions(+), 13 deletions(-)

The patch looks fine to me, and it seems to work well on my s390 LPAR.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
