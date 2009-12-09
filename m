Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZLIUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZLIUva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbZLIUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:51:19 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:38291 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922AbZLIUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:51:08 -0500
Date: Wed, 9 Dec 2009 21:51:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: ptrace: don't abuse PT_PTRACED
Message-ID: <20091209205112.GB4351@osiris.boeblingen.de.ibm.com>
References: <20091209194651.GA24919@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209194651.GA24919@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 08:46:51PM +0100, Oleg Nesterov wrote:
> Untested, but hopefully trivial enough and should't change the
> compiled code.
> 
> Nobody except ptrace itself should use task->ptrace or PT_PTRACED
> directly, change arch/s390/kernel/traps.c to use the helper.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Roland McGrath <roland@redhat.com>

> -	if ((current->ptrace & PT_PTRACED) != 0)
> +	if (tracehook_consider_fatal_signal(current, SIGTRAP))
>  		force_sig(SIGTRAP, current);

Thanks, applied. Even though I'm wondering why tracehook_consider_fatal_signal
has a signal parameter and doesn't do anything with it.
Is that something that will change with utrace?
