Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZKPMJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZKPMJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZKPMJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:09:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:57036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZKPMJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:09:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd
Date: Mon, 16 Nov 2009 13:09:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20091010153314.827301943@linutronix.de> <200911021651.53331.arnd@arndb.de> <20091116105427.GA17411@lst.de>
In-Reply-To: <20091116105427.GA17411@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911161309.47186.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+gxI6zCZSjpmY0MP0lsz2y9jj26Dpsv+7YnDR
 joZNM6erg/1AO00SasCIQlqL52I3Y7x1cNLq8iLil1pYcypaif
 viyMh/ulILDvsls+ooP+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 November 2009, Christoph Hellwig wrote:
> As mentioned before making generic_file_llseek the new default is
> probably a bad idea.  The majority of our file_operations instances
> don't actually support seeking, so no_llseek should become the new
> default if you spend some effort on converting things.  Anything that
> wants to allow seeking will have to set a llseek method.  This also
> mirrors what we do for other file operations.  None of the major ones
> has a non-trivial default, it's either silently succeeding for a
> selected few like open or release or returning an error for operatings
> that actually do something like read and write.

Ok, good point.

Do you think we should also prevent pread/pwrite for devices without
an llseek operation, like nonseekable_open does? I guess that would
be consistent.

Then there is the point that (I forgot who) brought up that changing
code to do no_llseek is actually an ABI change. Even if the file
position is never used anywhere, some random user application might
expect a chardev not to return an error when its llseek method is
called, resulting in regressions.

	Arnd <><
