Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZFBW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZFBW4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZFBW4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:56:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZFBW4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:56:03 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-4-git-send-email-ebiederm@xmission.com>
	<20090602071411.GE31556@wotan.suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 02 Jun 2009 15:56:02 -0700
In-Reply-To: <20090602071411.GE31556@wotan.suse.de> (Nick Piggin's message of "Tue\, 2 Jun 2009 09\:14\:11 +0200")
Message-ID: <m1tz2ykzy5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: npiggin@suse.de, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

>> In addition for a complete solution we need:
>> - A reliable way the file structures that we need to revoke.
>> - To wait for but not tamper with ongoing file creation and cleanup.
>> - A guarantee that all with user space controlled duration are removed.
>> 
>> The file_hotplug_lock has a very unique implementation necessitated by
>> the need to have no performance impact on existing code.  Classic locking
>
> Well, it isn't no performance impact. Function calls, branches, icache
> and dcache...

Practically none.

Everything I could measure was in the noise.  It is cheaper than any serializing
locking primitive.  I ran both lmbench and did some microbenchmark testing.
So I know on the fast path the overhead is minimal.  Certainly less than  what
we are doing in sysfs and proc today.

Eric

