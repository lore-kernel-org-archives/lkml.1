Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZA2Bic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZA2Bic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZA2BiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:38:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbZA2BiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:38:19 -0500
Date: Wed, 28 Jan 2009 17:37:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Patrick <steven@ngls.net>
Cc: jlayton@redhat.com, bugme-daemon@bugzilla.kernel.org,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 12564] New: poor performance while
 preprocessing source code
Message-Id: <20090128173730.9e4b9f0b.akpm@linux-foundation.org>
In-Reply-To: <1233190956.21519.13.camel@bluishred.int.infinisim.com>
References: <bug-12564-10286@http.bugzilla.kernel.org/>
	<20090128132942.c957a199.akpm@linux-foundation.org>
	<20090128170506.37161fb6@tleilax.poochiereds.net>
	<1233190956.21519.13.camel@bluishred.int.infinisim.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 17:02:36 -0800
Steven Patrick <steven@ngls.net> wrote:

> On Wed, 2009-01-28 at 17:05 -0500, Jeff Layton wrote:
> > 
> > It's a pretty small patch. The obvious question is: "What mount
> > options
> > are you using on your NFS mounts?"
> > 
> 
>   Well, I didn't think that I was using any NFS mounts.
> But, it turns out I was in a way.  Apparently, amd does its top
> level mounts with noac.  So, where this (using an automounted path):
>     cd /h/spo/work
>     make -j 5
> would be slow.  This (using a non-automounted path):
>     cd /home/spo/work
>     make -j 5
> showed the faster performance I was expecting.
>   I will mark my bug as invalid and decide what, if anything,
> I want to do about amd.
>   Thanks for pointing me in the right direction.
> 

This had me all mystified until I clicked on the bugzilla link:


:  ------- Comment  #9 From Trond Myklebust  2009-01-28 13:58:50  [reply] -------
: 
: If you are worried about performance, why are you using noac/actimeo=0?
: 
: The commit you point to fixed a bug in which the noac/actimeo=0 was
: using cached metadata in situations where it should have been
: retrieving the data from the server.  We fully expect a significant
: performance drop when the client is forced to send more GETATTR
: requests to the server, and as I said, that was precisely the point of
: this fix.

Fair enough.



However.  We surprised one user (yourself), and we will presumably
surprise others.  Or, worse, we will slow down people's stuff and they
won't even notice.

Should we perhaps warn people about this?  A mount-time printk telling
them that moac/actime=0 is slow?

