Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbZBJWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbZBJWRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZBJWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:17:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891AbZBJWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:17:15 -0500
Date: Tue, 10 Feb 2009 14:16:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: riel@redhat.com, wli@movementarian.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] vmscan: initialize sc->nr_reclaimed in
 do_try_to_free_pages()
Message-Id: <20090210141613.276a3c9c.akpm@linux-foundation.org>
In-Reply-To: <20090209222416.GA9758@cmpxchg.org>
References: <20090209222416.GA9758@cmpxchg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 23:24:16 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The commit missed to actually adjust do_try_to_free_pages() which now
> does not initialize sc.nr_reclaimed and makes shrink_zone() make
> assumptions on whether to bail out of the reclaim cycle based on an
> uninitialized value.

Both callers of do_try_to_free_pages() _do_ initialise
scan_control.nr_reclaimed.  The unitemised fields in a struct
initaliser are reliably zeroed.

We often rely upon this, and the only reason for mentioning such a
field is for documentation reasons, or if you want to add a comment at
the initialisation site.


