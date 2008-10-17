Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYJQPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYJQPet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYJQPek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:34:40 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:37426 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbYJQPej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:34:39 -0400
Date: Fri, 17 Oct 2008 17:34:36 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-arch@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 2/2] introduce vdso on s390
Message-ID: <20081017153436.GA17116@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-arch@vger.kernel.org,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20081015174506.107691579@de.ibm.com> <20081015175305.332585239@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081015175305.332585239@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 07:45:08PM +0200, Martin Schwidefsky wrote:
> +void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
> +{
> +	if (clock != &clocksource_tod)
> +		return;
> +
> +	/* Make userspace gettimeofday spin until we're done. */
> +	++vdso_data->tb_update_count;
> +	smp_mb();
> +	vdso_data->xtime_tod_stamp = clock->cycle_last;
> +	vdso_data->xtime_clock_sec = xtime.tv_sec;
> +	vdso_data->xtime_clock_nsec = xtime.tv_nsec;
> +	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
> +	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
> +	smp_wmb();

Different barriers?

> +	++(vdso_data->tb_update_count);

Why ++(...)?

Bastian

-- 
Either one of us, by himself, is expendable.  Both of us are not.
		-- Kirk, "The Devil in the Dark", stardate 3196.1
