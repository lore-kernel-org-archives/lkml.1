Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbZEKXtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbZEKXtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbZEKXso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:48:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759088AbZEKXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:48:43 -0400
Date: Mon, 11 May 2009 16:45:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: oleg@redhat.com, mingo@elte.hu, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-Id: <20090511164530.1842bb08.akpm@linux-foundation.org>
In-Reply-To: <1242048349-2766-2-git-send-email-v.mayatskih@gmail.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
	<1242048349-2766-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 15:25:50 +0200
Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> +	if (!retval && infop) {
> +		retval = put_user(signal, &infop->si_signo);
> +		if (!retval)
> +			retval = put_user(0, &infop->si_errno);
> +		if (!retval)
> +			retval = put_user((short)why, &infop->si_code);
> +		if (!retval)
> +			retval = put_user(pid, &infop->si_pid);
> +		if (!retval)
> +			retval = put_user(uid, &infop->si_uid);
> +		if (!retval)
> +			retval = put_user(status, &infop->si_status);
> +	}

I'll assume that "More changes to come" includes making all this somewhat
less inefficient ;)

