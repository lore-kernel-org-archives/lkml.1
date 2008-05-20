Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYETBuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYETBuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbYETBtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:49:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:10212 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYETBtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NBuWlRoidnWO4moIHDkosFanmZNDtqe/548zt9yPyK5HuzrHuT5PXIMAD73Lwewe43VPEosOsOo0M1rjRwLDZOcdKyCw5UDQHJUgajVCMLMG5K3B4AAe8Y2txRG0f3Q+IbnAS9LcOD7PHWMipF+xxcoxJUTyWYoE8pJt8fEVT2k=
Message-ID: <524f69650805191849ld32d627k3c2eff110dcf7f1a@mail.gmail.com>
Date: Mon, 19 May 2008 20:49:49 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "=?ISO-8859-1?Q?G=FCnter_Kukkukk?=" <linux@kukkukk.com>,
       samba-technical@lists.samba.org, linux-cifs-client@lists.samba.org
In-Reply-To: <1211244549.5915.111.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805191700g3e875e86gcb966033e9be60c1@mail.gmail.com>
	 <1211244549.5915.111.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 7:49 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Mon, 2008-05-19 at 19:00 -0500, Steve French wrote:
>> Harvey Harrison <harvey.harrison@gmail.com> wrote on 05/19/2008
>> Note that some of the backlevel server support issues aren't handled
>> by smbfs either (and are hard due to protocol limitations). Guenter
>> Kukkukk had been tracking some of the issues with better backlevel
>> support (mostly for OS/2 and Win9x servers) so he might have more
>> information, but the obvious holes that come to mind are:
>>
>> a) utimes to backlevel (lanman) servers
>> b) For some pre-Unicode servers it would help to be able to change the
>> code page used when translating readdir responses - so that we can
>> convert the server's readdir results from the old DBCS code pages to
>> UTF-8.
>> c) optionally zeroing pages on the client to work around the few buggy
>> old servers which don't zero on expanding file size remotely.
>> d) support for ancient dos ("core smb") servers
>>
>> There are also a few places where Jeff Layton noticed the cifs code
>> would always try the more recent smb command (which fails) and only
>> then issue the backlevel SMB command (in a few of the places, it would
>> be safe to "remember" the "operation not supported" answer or
>> equivalent so we don't have to first try a command which will always
>> fail).
>
> So it's generally people talking to older (or very old) servers that
> would be affected by this?  What options would they have if smbfs were
> removed?  Is there an alternative to smbfs that would work?  FUSE client?

They could use smbclient (an ftp like tool in the samba suite), but
there are no obvious reasons for another file system.

There are some usability improvements that could be made in mount.cifs
that might be all that is needed for 99% of the users of these very
old servers.  Currently mounting to old servers such as os/2 and win95
requires specifying a server "netbios name" (mount option
"servernetbiosname" is needed since netbiosnames are often different
than the server's tcp name) and also requires overriding the default
security settings (since the lanamn mechanism is much weaker than the
NTLMv2 and Kerberos mechanisms).   If we had an easier way of passing
information back across the mount sys call back to a mount helper this
would be easier to address (since we could send information on the
server's offered dialects and security mechanisms back to user space
so we could prompt the user).

-- 
Thanks,

Steve
