Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYBGKuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYBGKuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbYBGKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:50:04 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23238 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035AbYBGKt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:49:59 -0500
Message-ID: <47AAE250.8040702@msgid.tls.msk.ru>
Date: Thu, 07 Feb 2008 13:49:52 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
References: <47A9F495.8060400@msgid.tls.msk.ru> <20080207102815.GB26403@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080207102815.GB26403@atrey.karlin.mff.cuni.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
[deadlock after remount-ro followed with umount when
 quota is enabled]

>   Of course, thanks for report :). The problem is we allow remounting
> read only which we should refuse when quota is enabled. I'll fix that in
> a minute.

Hmm.  While that will prevent the lockup, maybe it's better to
perform an equivalent of quotaoff on mount-ro instead?  Or even
do something more useful, like flush the quota stuff like the
rest of the filesystem is flushed to disk, so that on umount,
quota will not stay on the way...

I mean, why it locks in the first place?  Quota subsystem trying
to write something into an read-only filesystem?  If so, WHY it
is trying to do that on umount instead on a remount-ro?

Thanks!

/mjt
