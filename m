Return-Path: <linux-kernel-owner+w=401wt.eu-S1765368AbXLTQgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765368AbXLTQgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765069AbXLTQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:36:21 -0500
Received: from tango.0pointer.de ([85.214.72.216]:33235 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765067AbXLTQgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:36:20 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 11:36:20 EST
Date: Thu, 20 Dec 2007 17:29:02 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <npiggin@suse.de>,
       riel <riel@redhat.com>
Subject: Re: [rfc][patch] mm: madvise(WILLNEED) for anonymous memory
Message-ID: <20071220162902.GA1945@tango.0pointer.de>
References: <1198155938.6821.3.camel@twins> <Pine.LNX.4.64.0712201339010.18399@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712201339010.18399@blonde.wat.veritas.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20.12.07 14:09, Hugh Dickins (hugh@veritas.com) wrote:

> > Lennart asked for madvise(WILLNEED) to work on anonymous pages, he plans
> > to use this to pre-fault pages. He currently uses: mlock/munlock for
> > this purpose.
> 
> I certainly agree with this in principle: it just seems an unnecessary
> and surprising restriction to refuse on anonymous vmas; I guess the only
> reason for not adding this was not having anyone asking for it until now.
> Though, does Lennart realize he could use MAP_POPULATE in the mmap?

Not really. First, if the mmap() is hidden somewhere in glibc (i.e. as
part of malloc() or whatever) it's not really possible to do
MAP_POPULATE. Also, I need this for some memory that is allocated
during the whole runtime but only seldomly used. Thus I am happy if it
is swapped out, but everytime I want to use it I want to make sure it
is paged in before I pass it on to the RT thread. So, there's a
mmap() during startup only, and then, during the whole runtime of my
program I want to page in the memory again and again, with long
intervals in between, but with no call to mmap()/munmap().

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
