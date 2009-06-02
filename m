Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZFBQ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZFBQ56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZFBQ5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:57:49 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39562 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZFBQ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:57:48 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 2 Jun 2009 09:51:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 18/23] vfs: Teach epoll to use file_hotplug_lock
In-Reply-To: <1243893048-17031-18-git-send-email-ebiederm@xmission.com>
Message-ID: <alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-18-git-send-email-ebiederm@xmission.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, Eric W. Biederman wrote:

> From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/eventpoll.c |   39 ++++++++++++++++++++++++++++++++-------
>  1 files changed, 32 insertions(+), 7 deletions(-)

This patchset gives me the willies for the amount of changes and possible 
impact on many subsystems.
Without having looked at the details, are you aware that epoll does not 
act like poll/select, and fds are not automatically removed (as in, 
dequeued from the poll wait queue) in any foreseeable amount of time after 
a POLLERR is received?
As far as the usespace API goes, they have the right to remain there.



- Davide


