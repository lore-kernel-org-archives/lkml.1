Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102Ab0AMWzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0AMWzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986Ab0AMWzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:55:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab0AMWzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:55:02 -0500
Date: Wed, 13 Jan 2010 14:54:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michal Schmidt <mschmidt@redhat.com>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Frans Pop <elendil@planet.nl>
Subject: Re: [RFC PATCH] accouting: account if a task was killed by OOM
 killer
Message-Id: <20100113145403.e44a5490.akpm@linux-foundation.org>
In-Reply-To: <1263192034-10898-1-git-send-email-dfeng@redhat.com>
References: <1263192034-10898-1-git-send-email-dfeng@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 14:40:34 +0800
Xiaotian Feng <dfeng@redhat.com> wrote:

> This patch introduces a new accounting flag which is set when a task
> was killed by OOM killer. taskstats can tell users when a job has been
> killed by the oomkiller.
> 

Why is this useful?  I'd be looking for a description of some
operational scenario where this feature is valuable to an operator?

The description is incomplete.  The patch also alters the contents of
the BSD accounting records.  That's a change to an ancient interface
and needs a bit of exposure and thought.  Is it good to put such a
highly linux-specific and somewhat linux-version-specific field into
such a venerable userspace interface?

If we _do_ decide to change the BSD accounting records in this manner
then presumably a manpage will need to be updated.  A cc to
linux-api@vger.kernel.org would be appropriate.

But I'm not very convinced about this whole idea at present, personally.

>  include/linux/acct.h                          |    1 +
>  include/linux/taskstats.h                     |    2 +-
>  kernel/acct.c                                 |    2 ++
>  kernel/tsacct.c                               |    2 ++

I'm a bit surprised that getdelays.c doesn't print ac_flag.


