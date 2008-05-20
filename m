Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbYETAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbYETAA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYETAAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:00:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:10965 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbYETAAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZXfOF9QlUXVTVJavbuRKZbtm0U7ucyV1cJ0vlM6DiAPwJwEeamJ9m0T5IFYkjQcOUykTR5KXXLlXhFxodUbdjvoQ2KBfyQEmumuT+0AdmJskZNBhfHQ2ooPZDx4JHK0ZWUiwSXvGjkvAZHB+4AWf6FbPxSrvjTaVZrUtzqCUPg8=
Message-ID: <524f69650805191700g3e875e86gcb966033e9be60c1@mail.gmail.com>
Date: Mon, 19 May 2008 19:00:12 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
Cc: "=?ISO-8859-1?Q?G=FCnter_Kukkukk?=" <linux@kukkukk.com>,
       samba-technical@lists.samba.org, linux-cifs-client@lists.samba.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote on 05/19/2008 06:06:10 PM:

> On Mon, 2008-05-19 at 18:03 -0500, Steven French wrote:
> > FYI - last week at connectathon I added one patch relating to backlevel
> > support and mapping of open flags on legacy smb open calls (although
> > perhaps some longtime smbfs users would not notice since smbfs did not
> > have this support either).
> >
> > The utimes support for backlevel servers is one obvious thing that I have
> > not added (but smbfs had some limited support for) but was considring
> > adding.
> >
>
> Just curious if there was a shortlist somewhere of anything supported in
> smbfs but not in cifs?
>
> Harvey

A partial list follows - let me know if you are aware of more (or even
better open bugs in the project bugzilla on samba.org)

Note that some of the backlevel server support issues aren't handled
by smbfs either (and are hard due to protocol limitations). Guenter
Kukkukk had been tracking some of the issues with better backlevel
support (mostly for OS/2 and Win9x servers) so he might have more
information, but the obvious holes that come to mind are:

a) utimes to backlevel (lanman) servers
b) For some pre-Unicode servers it would help to be able to change the
code page used when translating readdir responses - so that we can
convert the server's readdir results from the old DBCS code pages to
UTF-8.
c) optionally zeroing pages on the client to work around the few buggy
old servers which don't zero on expanding file size remotely.
d) support for ancient dos ("core smb") servers

There are also a few places where Jeff Layton noticed the cifs code
would always try the more recent smb command (which fails) and only
then issue the backlevel SMB command (in a few of the places, it would
be safe to "remember" the "operation not supported" answer or
equivalent so we don't have to first try a command which will always
fail).

Servers in the
-- 
Thanks,

Steve
