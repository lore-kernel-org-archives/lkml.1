Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXJVDpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXJVDpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXJVDp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:45:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43451 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532AbXJVDp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:45:28 -0400
X-Sasl-enc: b40J+nsLDhnMt1A5Xmr4xm4CpqTqKafl5O841d2uHQrc 1193024726
Subject: Re: 2.6.23-mm1 - autofs broken
From: Ian Kent <raven@themaw.net>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071020011310.30abc16b@bree.surriel.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <20071020011310.30abc16b@bree.surriel.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 11:45:19 +0800
Message-Id: <1193024720.3197.13.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-20 at 01:13 -0400, Rik van Riel wrote:
> On Thu, 11 Oct 2007 21:31:26 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > 
> > - I've been largely avoiding applying anything since rc8-mm2 in an
> > attempt to stabilise things for the 2.6.23 merge.
> 
> Between rc8-mm2 and 2.6.23-mm1, autofs stopped working in the
> -mm kernel.
> 
> Instead of mounting my home directory, I get these messages in
> /var/log/messages:
> 
> Oct 20 00:38:52 kenny automount[2293]: cache_readlock: mapent cache
> rwlock lock failed

This is quite strange, normally it should never fail and, in all the
time version 5 has been available the maximum number of read locks has
never been exceeded.

Is there anything unusual going on like a server down causing autofs to
issue a number of mounts that are all waiting to time out?

> Oct 20 00:38:52 kenny automount[2293]: unexpected pthreads error: 11 at
> 65 in cache.c

Mmm .. if this is a genuine autofs issue maybe I need to handle EAGAIN
returns but that would mean blocking which probably isn't good and I'd
rather not if we can avoid it.

> 
> I am not sure if this is due to autofs changes or changes in some other
> code that was merged.  If you can think of any suspicious change that
> I should test, please let me know.
> 

Is there anything in the log, an autofs4 kernel trace perhaps?

Ian

