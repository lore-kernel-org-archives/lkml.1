Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYETCnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYETCnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYETCnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:43:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbYETCnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:43:21 -0400
From: =?utf-8?q?G=C3=BCnter_Kukkukk?= <linux@kukkukk.com>
Organization: =?utf-8?q?Entwicklungsb=C3=BCro_f=C3=BCr?= Informationstechnologien
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
Date: Tue, 20 May 2008 04:40:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Steve French <smfrench@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, linux-cifs-client@lists.samba.org
References: <524f69650805191700g3e875e86gcb966033e9be60c1@mail.gmail.com> <1211244549.5915.111.camel@brick>
In-Reply-To: <1211244549.5915.111.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805200441.00236.linux@kukkukk.com>
X-Provags-ID: V01U2FsdGVkX1/BuQkZd1rtVjr6DpHSP+1DTzy5FKvF1+ZhxWQ
 oJey3uhyZ6I/LskPEhflDk8WFXgZjGziZBiL+pHg2hXRl/yvST
 Id3QBgmJ9ILrHmZXvZfil9b2GFuWGZy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Mai 2008 schrieb Harvey Harrison:
> On Mon, 2008-05-19 at 19:00 -0500, Steve French wrote:
> > Harvey Harrison <harvey.harrison@gmail.com> wrote on 05/19/2008 
> > Note that some of the backlevel server support issues aren't handled
> > by smbfs either (and are hard due to protocol limitations). Guenter
> > Kukkukk had been tracking some of the issues with better backlevel
> > support (mostly for OS/2 and Win9x servers) so he might have more
> > information, but the obvious holes that come to mind are:
> > 
> > a) utimes to backlevel (lanman) servers
> > b) For some pre-Unicode servers it would help to be able to change the
> > code page used when translating readdir responses - so that we can
> > convert the server's readdir results from the old DBCS code pages to
> > UTF-8.
> > c) optionally zeroing pages on the client to work around the few buggy
> > old servers which don't zero on expanding file size remotely.
> > d) support for ancient dos ("core smb") servers
> > 
> > There are also a few places where Jeff Layton noticed the cifs code
> > would always try the more recent smb command (which fails) and only
> > then issue the backlevel SMB command (in a few of the places, it would
> > be safe to "remember" the "operation not supported" answer or
> > equivalent so we don't have to first try a command which will always
> > fail).
> 
> So it's generally people talking to older (or very old) servers that
> would be affected by this?  What options would they have if smbfs were
> removed?  Is there an alternative to smbfs that would work?  FUSE client?
> 
> (Not affected personally, just curious what the alternatives are where
> cifs won't do it)
> 
> Harvey
> 
> 
> 

dropping smbfs in 2.6.27 will conflict with
  - legacy servers like
       - win9x/me
       - OS/2
       - even todays sold "samba NAS boxes (2.x.x)" (!!!)
       - other old legacy servers like MSDOS/IBMDOS

Cifs vfs - the successor of smbfs - was _initially_
designed to only support the "NT LM 0.12" and "POSIX 2"
SMB/CIFS network dialects - NO legacy support at all.

I really can't talk about "FUSE client" - the burden
is on cifs vfs ... to also support legacy servers.

Steve French has already mentioned "some 
not implemented legacy features".

What is not working today in cifs vfs (regarding legacy servers):
  - stat()
  - utimes()
  - ....

There might be more glitches ...

Cheers, Günter

Btw - work is done to solve the outstanding problems
