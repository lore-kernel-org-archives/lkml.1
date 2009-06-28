Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZF1TCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZF1TCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZF1TCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:02:45 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:59509 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1TCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SW1yp+fub3YX5iZXQx26twEd4Q2OJySj/m2NLBDuJPhppIkwy+hDT3+CU99tkWnWvU
         CEslk6pfKpHsPbn+UKjAfZWLxEMmLVhrmF3xBFJM+rW5SIeVfhQuge5DQx86O+pIgbdg
         wZwwXCCMRZtrjqV6JexiW11meFJHdSKjQJ+WU=
MIME-Version: 1.0
In-Reply-To: <524f69650906280943y447c0ee5oad516c4a7589c764@mail.gmail.com>
References: <1246100695-10344-1-git-send-email-jlayton@redhat.com>
	 <524f69650906271710n663e4f21x106b5deaa81e20c0@mail.gmail.com>
	 <1246152224.7960.1.camel@tupile.poochiereds.net>
	 <524f69650906280943y447c0ee5oad516c4a7589c764@mail.gmail.com>
Date: Sun, 28 Jun 2009 14:02:46 -0500
Message-ID: <524f69650906281202p6296c83esd9848931dfa4e8e8@mail.gmail.com>
Subject: Re: [linux-cifs-client] Re: [PATCH] cifs: fix fh_mutex locking in 
	cifs_reopen_file
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       Jeremy Allison <jra@samba.org>, samba-technical@lists.samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 11:43 AM, Steve French<smfrench@gmail.com> wrote:
> On Sat, Jun 27, 2009 at 8:23 PM, Jeff Layton<jlayton@redhat.com> wrote:
> In any case, as long as we are sure we are hitting a Samba server
> limit (or server side
> per-process limit), we are ok and can continue to review/merge the very large
> inode patches.  I am verifying with one additional pair of temporary
> stats (counters of successful opens) in the exit path of cifs_open and
> cifs_close)
> to make sure that those match what I have already verified that we are seeing
> with smbstatus and the client side counters on number of successful posix_opens.

I am puzzled about the Samba 3.4 max files limit (I am seeing it at
1014 opens) and seems
strange that dbench would open so many files, but with counters in
cifs_open and cifs_close - I see 1014 more opens than closes (from the vfs)
which matches what I see at the SMB level and what I see in Samba server.
dbench 4 fails even faster.   This also fails on other OS (opensuse,
Ubuntu etc.),
but worked on Samba 3.0.28.  Is it possible that Samba 3.4 changed their
max open file limit?


-- 
Thanks,

Steve
