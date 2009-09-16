Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZIPQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZIPQia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbZIPQiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:38:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:36314 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759717AbZIPQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:38:21 -0400
Date: Wed, 16 Sep 2009 12:38:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Howto switch off ext4's delayed allocation?
Message-ID: <20090916163822.GA15451@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Clemens Eisserer <linuxhippy@gmail.com>,
	linux-kernel@vger.kernel.org
References: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com> <194f62550909160532q248cb45coee639a2da10292a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194f62550909160532q248cb45coee639a2da10292a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 08:32:12AM -0400, Clemens Eisserer wrote:
> 
> Just happend again to me.
> After the intel driver crashed my system, the source-file I was
> working on was empty. Fourtunatly eclipse has a history-log.

Sounds like eclipse is broken; most Unix editors (emacs, vim, etc.) do
correctly use fsync() when writing precious files, such people's
source files.  In addition, it must be writing the data through a
decidedly non-standard way.  Is it out-and-out deleting the file
before writing the new version of the file, or something insane like
that?  Ext4's hueristics are designed so that for the most common ways
that applications update files, the data gets forced to disk.  It
sounds like Eclipse is doing something decidedly non-standard.

If you can run a strace on eclipse while and then arrange to edit an
existing file and save it, it would be interesting to see what the
heck it is doing.

> Isn't there a way to switch off the more "dangerous" optimizations in ext4?

The mount option nodelalloc will turn off delayed allocation.  This is
documented in Documentation/filesystems/ext4.txt.

					- Ted
