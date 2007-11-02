Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbXKBEWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbXKBEWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 00:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbXKBEV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 00:21:58 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:43303 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750712AbXKBEV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 00:21:57 -0400
X-YMail-OSG: 5amK65EVM1lovmS9MtXm84vppV7oPw32Uz0yQplDY_Gf6kIWm6VPRzVQbNTZBg8sBp4skXb6nQ--
X-RocketYMMF: rancidfat
Date: Thu, 1 Nov 2007 21:21:56 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>,
       Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87fxzp8v2c.fsf@olafdietsche.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <520194.24968.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de> wrote:

> Jan Kara <jack@suse.cz> writes:
> 
> > On Thu 01-11-07 20:49:32, Olaf Dietsche wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >> This patch implements filesystem capabilities. It allows to
> >> >> run privileged executables without the need for suid root.
> >> >   Hmm, is there some "design document" so that one does not have to poke
> >> > through the code and find out what it's actually trying to do?
> >> 
> >> What do you mean with "trying to do"? I thought this is obvious, it
> >> provides executables with filesystem capabilities.
> >   Well, yes, that was obvious but I rather meant "how is it doing it?".
> > So where does it store these bits and such.
> 
> The bits are stored in a sparse file named /.capabilities in the
> directory of the mount point, where the corresponding executable
> lives. The inode number of the file is the index into this file.

The old PlanG approach. It's the way that we did MAC labels in
Trix4. It has the wicked advantage of working across NFS without
anyone being the wiser. It really causes trouble for backup
utilities, however. Trix6 (there wasn't really a Trix5) had xattrs
available and we found the switch well worth the investment.


Casey Schaufler
casey@schaufler-ca.com
