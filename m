Return-Path: <linux-kernel-owner+w=401wt.eu-S933656AbYCABqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656AbYCABqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYCABqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:46:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:1205 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYCABqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:46:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZHJqsW1QxziSu2wdmbzwe1l9RJIcXViE8IPKNcg9ZS//kRgVg4GhT752Sl02EQDjUpJOVUiYV/Br8g7bXfivufU6oZdXWOFoOHwClO+ZvAYAgQiEB6Bo5x25nJGkk+Besk+jxbajnTVgx2c7FLMU/Yrj4KJXQ81pBCsICf1cd6E=
Message-ID: <b6fcc0a0802291746y7375ba71ja0dc0beb58c4ccb1@mail.gmail.com>
Date: Sat, 1 Mar 2008 04:46:41 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: ptb@inv.it.uc3m.es
Subject: Re: sysctl in 2.6.24.2 excludes unapproved files from /proc/sys?
Cc: "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200803010112.m211C5h4027092@betty.it.uc3m.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803010112.m211C5h4027092@betty.it.uc3m.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/08, Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> A change in 2.6.24.x kernel/sysctl.c seems to exclude exo-kernel drivers
> from using the /proc/sys/ interface:

That's somewhat correct.

> and IT TURNS OUT THAT (sorry, did I scream?)

Nobody gives a.

> sysctl_check_table can't
> succeed on anything that's now not been hardwired into the core kernel
> because of the new sysctl_check.c file which contains gazzilions of
> explict tables aying what is supposed to be in there in excruciating
> detail and which are consulted through sysctl_check_table and
> sysctl_binary_lookup. E.g:
>
> static struct trans_ctl_table trans_random_table[] = {
> { RANDOM_POOLSIZE, "poolsize" },
> { RANDOM_ENTROPY_COUNT, "entropy_avail" },
> { RANDOM_READ_THRESH, "read_wakeup_threshold" },
> { RANDOM_WRITE_THRESH, "write_wakeup_threshold" },
> { RANDOM_BOOT_ID, "boot_id" },
> { RANDOM_UUID, "uuid" },
> {}
> };
>
> It appears to me, not that I am totally sure because of the lack of
> comments,

Comments? You can read code, can't you?

> that every attempt to add a new direcotry in the tree with
> a number that is not listed in the above mess fails through
> sysctl_binary_lookup.sysctl_binary_lookup, and every attempt to add
> a directory with CTL_UNNUMBERED instead fails if it has children because
> the children cry about having an unnumbered parent. Every attempt to
> add a directory usurping an existing number fails through some string
> mismatch against the trans_.._tables on the dirnames in one of the
> numerous lookup functions (forget which).
>
> (somebody has really spent their holidays on this).
>
> What's a person to do?

If I understand you correcty, the answer is drop '.ctl_name' bits from
new sysctls and make sure common parts of tables match the ones
in mainline.
