Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbYDVOoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbYDVOoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763934AbYDVOoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:44:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763611AbYDVOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:44:21 -0400
Date: Tue, 22 Apr 2008 07:43:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
In-Reply-To: <1208851058-8500-2-git-send-email-jens.axboe@oracle.com>
Message-ID: <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jens Axboe wrote:
> +
> +static inline void csd_flag_wait(struct call_single_data *data)
> +{
> +	/* Wait for response */
> +	do {
> +		/*
> +		 * We need to see the flags store in the IPI handler
> +		 */
> +		smp_mb();
> +		if (!(data->flags & CSD_FLAG_WAIT))
> +			break;
> +		cpu_relax();
> +	} while (1);
> +}

You forgot to free the "data" here? The waiter must also free the object, 
since now the callee does not.

		Linus

