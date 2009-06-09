Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbZFIK3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbZFIK3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760786AbZFIKUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:55109 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760788AbZFIKUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:17 -0400
Date: Tue, 9 Jun 2009 12:20:14 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [0/16] HWPOISON: Intro
Message-ID: <20090609102014.GG14820@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603846.816684333@firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 08:46:31PM +0200, Andi Kleen wrote:
> Also I thought a bit about the fsync() error scenario. It's really
> a problem that can already happen even without hwpoison, e.g.
> when a page is dropped at the wrong time.

No, the page will never be "dropped" like that except with
this hwpoison. Errors, sure, might get dropped sometimes
due to implementation bugs, but this is adding semantics that
basically break fsync by-design.

I really want to resolve the EIO issue because as I said, it
is a user-abi issue and too many of those just get shoved
through only for someone to care about fundamental breakage
after some years.

You say that SIGKILL is overkill for such pages, but in fact
this is exactly what you do with mapped pages anyway, so why
not with other pages as well? I think it is perfectly fine to
do so (and maybe a new error code can be introduced and that
can be delivered to processes that can handle it rather than
SIGKILL).

Last request: do you have a panic-on-memory-error option?
I think HA systems and ones with properly designed data
integrity at the application layer will much prefer to
halt the system than attempt ad-hoc recovery that does not
always work and might screw things up worse.

