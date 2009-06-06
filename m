Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZFFIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZFFIIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFFIIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:08:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48094 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZFFIIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:08:19 -0400
Date: Sat, 6 Jun 2009 09:08:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 02/23] vfs: Implement unpoll_file.
Message-ID: <20090606080820.GA16867@ZenIV.linux.org.uk>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243893048-17031-2-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 02:50:27PM -0700, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
> 
> During a revoke operation it is necessary to stop using all state that is managed
> by the underlying file operations implementation.  The poll wait queue is one part
> of that state.

Erm...  Seeing that drivers and filesystems tend to have fsckloads of
other state of their own, why do we treat that separately?
