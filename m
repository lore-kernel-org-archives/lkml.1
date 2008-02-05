Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbYBEUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbYBEUmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbYBEUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:42:30 -0500
Received: from styx.suse.cz ([82.119.242.94]:49622 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759035AbYBEUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:42:29 -0500
Date: Tue, 5 Feb 2008 21:42:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
In-Reply-To: <20080205180519.GA1525@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0802052139460.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
 <20080205180519.GA1525@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pavel Machek wrote:

> Sorry, I now tested the patch. It looked good to my untrained eyes, but 
> upon testing it on columns:
> ...
> personality(PER_LINUX)                  = 4194304
> geteuid()                               = 1000
> getuid()                                = 1000
> getgid()                                = 1002
> getegid()                               = 1002
> brk(0x8054098)                          = 0x922d000
> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> ...it should have said -EINVAL or something like that.

I don't think so.

brk() should return the value of the current break when passed an 
unreasonable argument (as in the case you ilustrated -- it tried to set 
the brk lower than start_brk, which doesn't make sense). The only error 
values brk() is allowed to return are ENOMEM and EAGAIN, which don't fit 
into this situation. This is desgribed both in SUS and linux manpages.

-- 
Jiri Kosina
SUSE Labs
