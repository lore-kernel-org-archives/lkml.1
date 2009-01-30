Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZA3KGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZA3KGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZA3KF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:05:59 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:50666 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZA3KF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:05:58 -0500
Date: Fri, 30 Jan 2009 11:05:55 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v2)
Message-ID: <20090130110555.116f747a@gondolin>
In-Reply-To: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
References: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
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

On Fri, 30 Jan 2009 10:31:42 +0800,
tom.leiming@gmail.com wrote:


>  /**
> + * driver_wait_probe_done_and_dev_appear
> + * wait until the probe sequence is finished _and_ the dev @name appears.
> + *
> + */
> +void driver_wait_probe_done_and_dev_appear(char *name)
> +{
> +	pr_debug("%s: probe_count = %d\n", __func__,
> +		 atomic_read(&probe_count));
> +
> +	wait_event(probe_waitqueue, (atomic_read(&probe_count) == 0) &&
> +		  name_to_dev_t(name));

probe_waitqueue is only woken at the end of really_probe(), not when
whatever needs to be done to make the device available is done...

> +}
> +/**
>   * driver_probe_device - attempt to bind device & driver together
>   * @drv: driver to bind a device to
>   * @dev: device to try to bind to the driver
