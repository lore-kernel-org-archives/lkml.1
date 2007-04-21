Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXDUQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXDUQcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXDUQcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:32:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:53959 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbXDUQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qm5ogtYMmQgP2c7OiHYemSTFB85NlKr0s3HCxnryfnAVXOCZCLVrG9exuMWLGggKMmFQMs4X1wtik0tulMhFBnu2f+Y8TC7iphqZ9OQGgQ0vr7GE1NjuQbqIyvXfWHagU2YOt+QGH501mw4LK7fGP25ykzAFI5+hbOZl5VQmC+0=
Message-ID: <a36005b50704210932h3fe775ebv392a407054675eef@mail.gmail.com>
Date: Sat, 21 Apr 2007 09:32:15 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE 2/2
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, "Jakub Jelinek" <jakub@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0704210830310.26485@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46247427.6000902@redhat.com> <4627DBF0.1080303@redhat.com>
	 <20070420140316.e0155e7d.akpm@linux-foundation.org>
	 <a36005b50704201424q3c07d457m6b2c468ff8a826c7@mail.gmail.com>
	 <Pine.LNX.4.64.0704210830310.26485@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Hugh Dickins <hugh@veritas.com> wrote:
> But the Linux MADV_DONTNEED does throw away
> data from a PROT_WRITE,MAP_PRIVATE mapping (or brk or stack) - those
> changes are discarded, and a subsequent access will revert to zeroes
> or the underlying mapped file.  Been like that since before 2.4.0.

I didn't say it changed.  I just say that there is a hole in the
current implementation as it does not allow to implement
POSIX_MADV_DONTNEED with anything but a no-op.  The
POSIX_MADV_DONTNEED behavior is useful and something IMO should be
added to allow implementing it.
