Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZLQHGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZLQHGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZLQHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:06:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49435 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbZLQHGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=TfmLm9vg2mwJSvvhO4jX/tJwDYNEn8lE2uE6gutWw5xSwNdEOZe5Fl8/DsBoM+d8de
         eMzO2Gm43NW9/v7MQSAePabnBV3WazapRHkI2H07iWwQvA4WvwODtod5TtxiiM6G0dmj
         LgfDey5W84iuNdLP9B10J2hJzD7wwDINBXmdo=
MIME-Version: 1.0
In-Reply-To: <4B292D9A.5060501@poelzi.org>
References: <4B292D9A.5060501@poelzi.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 17 Dec 2009 02:06:15 -0500
Message-ID: <3e8340490912162306m4236569s4e497ad01409c756@mail.gmail.com>
Subject: Re: Suggestion: xtime as new inode attribute
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
       Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 1:57 PM, Daniel Poelzleithner <poelzi@poelzi.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi,
>
> I would like to suggest a new attribute for inodes in linux filesystems
> to record the last execution time of files.
>
> The problem:
>
> If a linux installation gets older and older, more and more programs get
> installed over time. Mostly to just test them for a particular problem
> and often the deinstallation is forgotten. To find out which packages
> are not used for a long time is currently quite impossible. The user may
> use program X which will run but not depend on program Y as a subprocess
> for example.
>
> The solution:
>
> I suggest a new inode attribute called xtime, which is like atime, but
> will only be updated when a file is executed. This would allow tracking
> of unused binaries and could be used with some clever algorithms in the
> cleanup program to find unused packages for removal or other cleanup
> purposes.
> It would also add an additional information in forensic analysis of
> hacked systems btw.

Why isn't atime sufficient? atime is updated when programs are
executed, and it's uncommon for executable files to be accessed
without being executed; for the purposes of determining whether a
program is needed, it ought to be good enough.

Note that many modern distros use relatime to reduce the (significant)
overhead of atime; this may account for why you may not be seeing
atime update for executables; try mounting with -o strictatime if you
want to see it at work, but beware, as this will bring with it a major
performance hit - which your proposal would as well :)
