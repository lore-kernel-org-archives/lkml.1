Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYCCXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYCCXYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYCCXYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:24:03 -0500
Received: from ns.suse.de ([195.135.220.2]:55338 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYCCXYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:24:01 -0500
To: Cyrus Massoumi <cyrusm@gmx.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Diego Calleja <diegocg@gmail.com>,
       Stephen Cuppett <cuppett@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Performance versus FreeBSD 7.0
From: Andi Kleen <andi@firstfloor.org>
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
	<20080229155408.116fa5a1.diegocg@gmail.com>
	<200803040004.52299.nickpiggin@yahoo.com.au>
	<47CC4B3F.8060405@gmx.net>
Date: Tue, 04 Mar 2008 00:23:59 +0100
In-Reply-To: <47CC4B3F.8060405@gmx.net> (Cyrus Massoumi's message of "Mon\, 03 Mar 2008 20\:02\:23 +0100")
Message-ID: <p73y78z5r3k.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrus Massoumi <cyrusm@gmx.net> writes:
>
> IIRC, going to fine-grained file locking gave them a huge boost in
> this particular benchmark (and maybe others).

What locking? You mean their equivalent of i_mutex? There are 
already file systems on Linux that don't use it significantly
for write.

> As I said on lwn.net Peter Zijlstra posted a patch to break the global
> file list lock about a year ago [1], but I don't think it was ever
> merged. Here [2] are some numbers for the patchset.

The file_list_lock is only for open/close which MySQL is very unlikely
to do in its fast path. You're totally on the wrong path here I think.

-Andi
