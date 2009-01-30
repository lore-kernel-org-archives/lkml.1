Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZA3Nbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZA3Nbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZA3Nbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:31:35 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:38451 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZA3Nbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:31:34 -0500
Date: Fri, 30 Jan 2009 14:31:31 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v3)
Message-ID: <20090130143131.0214a887@gondolin>
In-Reply-To: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com>
References: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com>
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

On Fri, 30 Jan 2009 20:48:35 +0800,
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch adds a function : driver_wait_probe_done,
> which waits on condition of probing done to replace
> polling for driver_probe_done in fs initialization.
> 
> There is no better way to avoid polling for
> driver_probe_done _and_ existence of the root device,
> so we does not replace the driver_probe_done with
> driver_wait_probe_done in such special case.
> 
> Removing polling in fs initialization may lead to
> a faster boot.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/base/dd.c      |   12 ++++++++++++
>  include/linux/device.h |    1 +
>  init/do_mounts.c       |    4 ++--
>  init/do_mounts_md.c    |    3 +--
>  4 files changed, 16 insertions(+), 4 deletions(-)

Looks good and also survived a quick test on my s390 LPAR.
