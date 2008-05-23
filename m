Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbYEWFzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYEWFzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYEWFzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:55:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbYEWFzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:55:02 -0400
Date: Thu, 22 May 2008 22:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Steve French" <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: pagevecs of more than PAGEVEC_SIZE pages
Message-Id: <20080522225459.5a6f7acc.akpm@linux-foundation.org>
In-Reply-To: <524f69650805221213i62488a4fk5a906b2726b9b96a@mail.gmail.com>
References: <524f69650805221213i62488a4fk5a906b2726b9b96a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 14:13:07 -0500 "Steve French" <smfrench@gmail.com> wrote:

> Now that various servers support processing larger than 64K file
> writes, it would be helpful to have pagevecs that are larger than 14
> pages (PAGEVEC_SIZE).so an array of more pages could be passed to
> kernel_sendmsg (thus allowing writes larger than 56K, depending on
> wsize - the server limit is currently 8MB)

You can pass multiple pagevecs into kernel_sendmsg?

> pagevec_lookup_tag (and the inline function pagevec_space which I
> don't use) is the main place that cifs needs a pagevec instead of
> simply an array of pages and PAGEVEC_SIZE does not seem to matter
> there (it works if I malloc a structure with more pages and request
> more than 14 pages out of pagevec_lookup_tag).  Is there another
> better alternative other than defining a larger pagevec (pagevec2 or
> cifs_pagevec)?  Should I simply kmalloc something larger than a
> pagevec and cast a (struct pagevec *) to it?

We could make pagevecs variable-sized easily enough - add a `struct
page **' to it.  But it's more overhead and this is the first time I've
seen demand for it?

