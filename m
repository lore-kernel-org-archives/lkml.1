Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZF1RKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZF1RKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZF1RKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:10:37 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48382 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZF1RKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G2gQyfqL4XzZV+NOoUgq5EKE2A0Qpritkr8oqJHuk/ycBqnCxXknK7Ol/iLzGc6VWz
         D4Q87wDTm9vNJKVQQL2TlPT7fR24py7Al9/OkTy1HyvTYencs82W93NvpPZCqJgPoVby
         1efKxS5aviy1C79Viq2vFg3ATkzp0pZM2cBjY=
MIME-Version: 1.0
In-Reply-To: <1246152224.7960.1.camel@tupile.poochiereds.net>
References: <1246100695-10344-1-git-send-email-jlayton@redhat.com>
	 <524f69650906271710n663e4f21x106b5deaa81e20c0@mail.gmail.com>
	 <1246152224.7960.1.camel@tupile.poochiereds.net>
Date: Sun, 28 Jun 2009 11:43:36 -0500
Message-ID: <524f69650906280943y447c0ee5oad516c4a7589c764@mail.gmail.com>
Subject: Re: [linux-cifs-client] Re: [PATCH] cifs: fix fh_mutex locking in 
	cifs_reopen_file
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 8:23 PM, Jeff Layton<jlayton@redhat.com> wrote:
> On Sat, 2009-06-27 at 19:10 -0500, Steve French wrote:
>> Good catch .
>>
>> I have reviewed and merged into cifs-2.6.git. Merge requested for upstream.
>>
> Great. Did it fix the problems you were seeing when testing with dbench?

I doubt that this patch would affect my dbench runs because I wasn't
getting any network
reconnections (they would have logged a warning to dmesg) and the fix
is in reopen_file (which is invoked on reconnections).

I am updating and building current samba3 on a different machine (the one I
more frequently run dbench test runs on) to check on whether this is an
Ubuntu specific limit which I had not seen before (I usually run dbench with
50 rather than 60 processes).  The Samba handle limit should (and was)
be quite large.

In any case, as long as we are sure we are hitting a Samba server
limit (or server side
per-process limit), we are ok and can continue to review/merge the very large
inode patches.  I am verifying with one additional pair of temporary
stats (counters of successful opens) in the exit path of cifs_open and
cifs_close)
to make sure that those match what I have already verified that we are seeing
with smbstatus and the client side counters on number of successful posix_opens.



-- 
Thanks,

Steve
