Return-Path: <linux-kernel-owner+w=401wt.eu-S1765050AbYEAT1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765050AbYEAT1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759309AbYEAT1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:27:25 -0400
Received: from mail.suse.de ([195.135.220.2]:35497 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293AbYEAT1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:27:24 -0400
Message-ID: <481A1994.5020000@suse.com>
Date: Thu, 01 May 2008 15:27:16 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, jeffschroeder@computer.org,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs v0.14 Released
References: <200804291601.32945.chris.mason@oracle.com> <c24352ca0805010939q31f743aev17cc7f98d2ad0c71@mail.gmail.com> <481A14BA.9090305@canonical.com> <200805011517.55698.chris.mason@oracle.com>
In-Reply-To: <200805011517.55698.chris.mason@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Mason wrote:
> On Thursday 01 May 2008, Tim Gardner wrote:
> 
> [ btrfs oops on ubuntu ]
> 
>>>>  This is because ubuntu kernels ship with apparmor, you'll need this
>>>> patch:
>>>>
>>>>  If there is a #ifdef IM_A_UBUNTU_KERNEL I can use, I'll do it.  Jeff
>>>> Mahoney has a similar patch for SUSE that I've been meaning to merge,
>>>> but I wanted to lookup some way to check for ubuntu as well.
>>>>
>>>>  -chris
>>>>
>>>>  diff -r e7da2489b19b file.c
>>>>  --- a/file.c    Wed Apr 30 13:59:35 2008 -0400
>>>>  +++ b/file.c    Thu May 01 12:25:11 2008 -0400
>>>>  @@ -852,7 +852,7 @@ static ssize_t btrfs_file_write(struct f
>>>>                 goto out_nolock;
>>>>         if (count == 0)
>>>>                 goto out_nolock;
>>>>  -       err = remove_suid(fdentry(file));
>>>>  +       err = remove_suid(&file->f_path);
>>>>         if (err)
>>>>                 goto out_nolock;
>>>>         file_update_time(file);
>> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
>> work for Hardy. However the next development kernel (Intrepid) does not
>> have the APPARMOR patches, so just knowing that its an UBUNTU kernel is
>> not specific enough.
> 
> I've been assuming the apparmor patches change remove_suid even when they are 
> not enabled in the config.

Yeah, unless Ubuntu is doing some magic with the function arguments
(which sounds like the fix is worse than the problem), this is true.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIGhmULPWxlyuTD7IRAgJcAJ4zYYcgQ2V0eT6Fv6LstlwpnK9bUwCgpdBD
XHUzfiFBd+HQLt5Tw5vHH0A=
=KWIZ
-----END PGP SIGNATURE-----
