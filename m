Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbXFLXvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbXFLXvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXFLXuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:50:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:39981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbXFLXuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:50:54 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Date: Wed, 13 Jun 2007 01:50:50 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706110110.35553.agruen@suse.de> <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1181572416.8805.73.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2336
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200706130150.51140.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007 16:33, Stephen Smalley wrote:
>From a userland perspective, audit and inotify allow you to specify
> watches on pathnames, and those watches trigger actions by the audit and
> inotify subsystems when those files are accessed.  The kernel mechanism
> however is inode-based, not pathname-based; the pathname is merely
> looked up when the watch is added and mapped to an inode.  That's my
> point - why should AA be different?

Audit watches are not entirely object based (contrary to what the man page 
says): with simple file renames the watches sticks with the names; with 
directory renames, watches below the directory get dropped. That's rather 
weird, and I would say bad for audit.

Inotify really watches objects. I can imagine cases where this is exactly what 
you want, and others where this is exactly what you don't want -- it's pick 
your poison.

AppArmor deliberately is pathname based. There are good reasons for that, and 
we really, definitely want this pathname based model, with all its benefits 
and disadvantages. Arguing that AppArmor shouldn't be pathname based because 
other parts of the kernel try to balance names vs. objects differently, and 
not even always the same way either, is pretty narrow-minded.

If one thing is clear from this entire discussion, it is that there is no 
agreement on the One True Model, and different solutions are being used.

> Would you really recommend that audit or inotify call d_path() on each
> open and glob match the result against a list of audit or inotify watches?

I don't remember doing so.

Thanks,
Andreas
