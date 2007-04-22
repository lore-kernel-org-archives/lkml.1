Return-Path: <linux-kernel-owner+w=401wt.eu-S1161495AbXDVQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161495AbXDVQzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161499AbXDVQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:55:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:47542 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161495AbXDVQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W7OQMnsmx41m207BwvmHLccITvrDqX4hTg4pYB/rabqF/smExPGfUYRos6rgE6G2LlJdIQfa60TZFW78Nzy768KSeO3OyNLLMxQL+uC0E6XJykjTw3Nlm7cy1VGtHUJQr7rEYrMKSOap+gzt6jdd3sV62MVnhO8TrZxLIJjPnGI=
Message-ID: <a36005b50704220955u7153ea76sef403442bbc805a5@mail.gmail.com>
Date: Sun, 22 Apr 2007 09:55:18 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
In-Reply-To: <20070422091658.GB1558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46247427.6000902@redhat.com>
	 <20070422011810.e76685cc.akpm@linux-foundation.org>
	 <20070422091658.GB1558@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, Christoph Hellwig <hch@infradead.org> wrote:
> Why isn't MADV_FREE defined to 5 for linux?  It's our first free madv
> value?  Also the behaviour should better match the one in solaris or BSD,
> the last thing we need is slightly different behaviour from operating
> systems supporting this for ages.

The behavior should indeed be identical.  Both implementations
restrict MADV_FREE to work on anonymous memory and it is unspecified
whether a renewed access yields to a zerod page being created or
whether the old content is still there.  So, just use 0x5 for both the
Linux and Solaris version on sparc.
