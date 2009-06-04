Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZFDA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZFDA4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZFDA4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:56:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38791 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZFDA4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:56:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 3 Jun 2009 17:50:01 -0700 (PDT)
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
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 18/23] vfs: Teach epoll to use file_hotplug_lock
In-Reply-To: <m1tz2xox7n.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0906031708480.18001@makko.or.mcafeemobile.com>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-18-git-send-email-ebiederm@xmission.com> <alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com> <m1eiu2qqho.fsf@fess.ebiederm.org> <alpine.DEB.1.10.0906021429570.12866@makko.or.mcafeemobile.com>
 <m13aaintb1.fsf@fess.ebiederm.org> <alpine.DEB.1.10.0906030754550.17143@makko.or.mcafeemobile.com> <m1tz2xox7n.fsf@fess.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Eric W. Biederman wrote:

> What code are you talking about?
> 
> To the open path a few memory writes and a smp_wmb.  No atomics and no
> spin lock/unlocks.
> 
> Are you complaining because I retain the file_list?

Sorry, did I overlook the patch? Weren't a couple of atomic ops and a spin 
lock/unlock couple present in __dentry_open() (same sort of the release 
path)?
And that's only like 5% of the code touched by the new special handling of 
the file operations structure (basically, every f_op access ends up being 
wrapped by two atomic ops and other extra code).
The question, that I'd like to reiterate is, is this stuff really needed?
Anyway, my complaint ends here and I'll let others evaluate if merging 
this patchset is worth the cost.


- Davide


