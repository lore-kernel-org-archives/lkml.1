Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZERLLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZERLLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZERLKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:10:55 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49288 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZERLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:10:54 -0400
Date: Mon, 18 May 2009 13:10:54 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] kernel:async function call:introduce
 async_run_inatomic(v3)
Message-ID: <20090518131054.1ace6885@gondolin>
In-Reply-To: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
References: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 21:54:17 +0800,
tom.leiming@gmail.com wrote:

> + /**
> + * async_run_inatomic - in atomic contexts schedule a function for
> + * 			asynchronous execution
> + *
> + * @ptr: function to execute asynchronously
> + * @data: data pointer to pass to the function
> + *
> + * The purpose of this function is to offer a simple way to schedule an
> + * asynchronous thread from an atomic context.
> + *
> + * Return zero one success, !zero on failured
> + * Note: async_run_inatomic() uses a distinct running list in order
> + * to avoid slowing down synchronization within the general domain.
> + * Since it does not return a cookie for checkpointing, it is for callers
> + * that don't need later synchronization.
> + */
> +int async_run_inatomic(async_func_ptr *ptr, void *data)
> +{
> +	return !__async_schedule(ptr, data, &async_running_no_sync, 1);
> +}
> +EXPORT_SYMBOL_GPL(async_run_inatomic);
> +

While we can skip synchronization on cookies, we still need something
like async_run_synchronize() for module unloading (and possibly others).
