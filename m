Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZF1XSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZF1XSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 19:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZF1XSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 19:18:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54695 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZF1XSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 19:18:14 -0400
Subject: Re: [linux-cifs-client] Re: [PATCH] cifs: fix fh_mutex locking in 
 cifs_reopen_file
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       Jeremy Allison <jra@samba.org>, samba-technical@lists.samba.org
In-Reply-To: <524f69650906281202p6296c83esd9848931dfa4e8e8@mail.gmail.com>
References: <1246100695-10344-1-git-send-email-jlayton@redhat.com>
	 <524f69650906271710n663e4f21x106b5deaa81e20c0@mail.gmail.com>
	 <1246152224.7960.1.camel@tupile.poochiereds.net>
	 <524f69650906280943y447c0ee5oad516c4a7589c764@mail.gmail.com>
	 <524f69650906281202p6296c83esd9848931dfa4e8e8@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 19:18:09 -0400
Message-Id: <1246231089.2956.3.camel@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 14:02 -0500, Steve French wrote:
> On Sun, Jun 28, 2009 at 11:43 AM, Steve French<smfrench@gmail.com> wrote:
> > On Sat, Jun 27, 2009 at 8:23 PM, Jeff Layton<jlayton@redhat.com> wrote:
> > In any case, as long as we are sure we are hitting a Samba server
> > limit (or server side
> > per-process limit), we are ok and can continue to review/merge the very large
> > inode patches.  I am verifying with one additional pair of temporary
> > stats (counters of successful opens) in the exit path of cifs_open and
> > cifs_close)
> > to make sure that those match what I have already verified that we are seeing
> > with smbstatus and the client side counters on number of successful posix_opens.
> 
> I am puzzled about the Samba 3.4 max files limit (I am seeing it at
> 1014 opens) and seems
> strange that dbench would open so many files, but with counters in
> cifs_open and cifs_close - I see 1014 more opens than closes (from the vfs)
> which matches what I see at the SMB level and what I see in Samba server.
> dbench 4 fails even faster.   This also fails on other OS (opensuse,
> Ubuntu etc.),
> but worked on Samba 3.0.28.  Is it possible that Samba 3.4 changed their
> max open file limit?
> 
> 

Doesn't 3.0.28 have broken POSIX open calls? That may account for the
difference. I can't be certain I was seeing the same failures you were
with dbench, but I never got a passing run until I applied that patch to
fix the reopen locking.

-- 
Jeff Layton <jlayton@redhat.com>

