Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbYETOqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbYETOqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932660AbYETOqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:46:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:60510 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbYETOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:46:07 -0400
Date: Tue, 20 May 2008 15:45:50 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080520144550.GB16676@shareable.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <20080516225304.GG15334@shareable.org> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <20080517134344.GA7411@mit.edu> <20080517204437.GB16496@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080517204437.GB16496@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Also, looking more closely on the jbd2 implementation, it looks like
> using the async_commit option, which relies on the checksum for more
> efficient commit, completely disables any barrier support.  That's
> because the only place we go into ordered more is if we are writing a
> synchronous journal commit.  If async journal commit is enabled, then
> we don't write a barrier at all, which leaves us in potential trouble
> with if data blocks end up getting reordered with respect to the
> journal commit in data=ordered more.

That is a great optimisation to make the filesystem safe against power
fails without barriers.  Upon replay, the filesystem is consistent.

But does it break fsync()?  Consistency isn't enough for fsync().
Returning from fsync() means "this data is committed now".

-- Jamie
