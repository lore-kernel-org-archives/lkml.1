Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYA1URq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYA1URq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYA1URe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:17:34 -0500
Received: from [212.12.190.100] ([212.12.190.100]:54394 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751474AbYA1URc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:17:32 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Mon, 28 Jan 2008 23:17:19 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <200801260827.59675.a1426z@gawab.com> <20080128172726.GG14038@duck.suse.cz>
In-Reply-To: <20080128172726.GG14038@duck.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801282317.19124.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Sat 26-01-08 08:27:59, Al Boldi wrote:
> > Do you mean there is a locking problem?
>
>   No, but if you write to an mmaped file, then we can find out only later
> we have dirty data in pages and we call writepage() on behalf of e.g.
> pdflush().

Ok, that's a special case, which we could code for, but doesn't seem 
worthwile.  In any case, child-forks should inherit its parent mode.

> > > And in case of DB, they use direct-io
> > > anyway most of the time so they don't care about journaling mode
> > > anyway.
> >
> > Testing with sqlite3 and mysql4 shows that performance drastically
> > improves with writeback writeout.
>
>   And do you have the databases configured to use direct IO or not?

I don't think so, but these tests are only meant to expose the underlying 
problem which needs to be fixed, while this RFC proposes a useful 
workaround.

In another post Jan Kara wrote:
>   Hmm, if you're willing to test patches, then you could try a debug
> patch: http://bugzilla.kernel.org/attachment.cgi?id=14574
>   and send me the output. What kind of load do you observe problems with
> and which problems exactly?

8M-record insert into indexed db-table:
         ordered  writeback
sqlite3:  75m22s    8m45s
mysql4 :  23m35s    5m29s

Also, see the 'konqueror deadlocks in 2.6.22' thread.


Thanks!

--
Al

