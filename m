Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZFCUyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZFCUyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZFCUx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:53:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54649 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZFCUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:53:55 -0400
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 18/23] vfs: Teach epoll to use file_hotplug_lock
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-18-git-send-email-ebiederm@xmission.com>
	<alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com>
	<m1eiu2qqho.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0906021429570.12866@makko.or.mcafeemobile.com>
	<m13aaintb1.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0906030754550.17143@makko.or.mcafeemobile.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 13:53:48 -0700
In-Reply-To: <alpine.DEB.1.10.0906030754550.17143@makko.or.mcafeemobile.com> (Davide Libenzi's message of "Wed\, 3 Jun 2009 07\:57\:40 -0700 \(PDT\)")
Message-ID: <m1tz2xox7n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: davidel@xmailserver.org, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Tue, 2 Jun 2009, Eric W. Biederman wrote:
>
>> I am not clear what problem you have.
>> 
>> Is it the sprinkling the code that takes and removes the lock?  Just
>> the VFS needs to be involved with that.  It is a slightly larger
>> surface area than doing the work inside the file operations as we
>> sometimes call the same method from 3-4 different places but it is
>> definitely a bounded problem.
>> 
>> Is it putting in the handful lines per subsystem to actually use this
>> functionality?  At that level something generic that is maintained
>> outside of the subsystem is better than the mess we have with 4-5
>> different implementations in the subsystems that need it, each having
>> a different assortment of bugs.
>
> Come on, only in the open fast path, there are at least two spin 
> lock/unlock and two atomic ops. Without even starting to count all the 
> extra branches and software added.
> Is this stuff *really* needed, or we can faitly happily live w/out?

????

What code are you talking about?

To the open path a few memory writes and a smp_wmb.  No atomics and no
spin lock/unlocks.

Are you complaining because I retain the file_list?

Eric
