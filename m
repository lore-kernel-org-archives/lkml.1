Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935Ab0A0SAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0A0SAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205Ab0A0SAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:00:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab0A0SAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:00:21 -0500
Date: Wed, 27 Jan 2010 18:58:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, abelay@mit.edu,
       benh@kernel.crashing.org, drbd-dev@lists.linbit.com, gregkh@suse.de,
       jmoskovc@redhat.com, menage@google.com, mfasheh@suse.com,
       mingo@redhat.com, neilb@suse.de, shemminger@linux-foundation.org,
       spock@gentoo.org, t.sailer@alumni.ethz.ch, takedakn@nttdata.co.jp,
       viro@zeniv.linux.org.uk
Subject: Re: +
	exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather
	-than-0.patch added to -mm tree
Message-ID: <20100127175852.GA7511@redhat.com>
References: <201001262354.o0QNsBiM029772@imap1.linux-foundation.org> <20100127174706.GA6333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127174706.GA6333@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Oleg Nesterov wrote:
>
> Currently only d_coredump() needs this new feature, but please note
> that ____call_usermodehelper() was already "uglified" for the coredumping
> over the pipe.
>
> If we add sub_info->finit(), then probably we should move the code
> under "if (sub_info->stdin)" from ____call_usermodehelper() to
> core_pipe_setup() ?

And, perhaps, we should not change call_usermodehelper() and all its
callers? If the caller needs ->finit() it can customize subprocess_info
like call_usermodehelper_pipe() already does?

To clarify, I don't have a "strong" opinion, I am just asking.

Oleg.

