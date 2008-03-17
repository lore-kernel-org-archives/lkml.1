Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYCQXyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYCQXyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYCQXyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:54:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYCQXyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:54:43 -0400
From: Andreas Schwab <schwab@suse.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
References: <47DEFE26.80101@msgid.tls.msk.ru>
X-Yow: Where's the Coke machine?  Tell me a joke!!
Date: Tue, 18 Mar 2008 00:54:40 +0100
In-Reply-To: <47DEFE26.80101@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Tue\, 18 Mar 2008 02\:26\:30 +0300")
Message-ID: <jeabkwaou7.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

>   # ls -l /dev/pts/0
>   crw--w---- 1 root tty 136, 0 Mar 18 02:19 /dev/pts/0
>
> So far so good.  Now, I change uid to something else, --
> doing su(8) to "mjt".  /proc/self changed obviously,
> but stdin &Co is still here, and points to the same
> /dev/pts/0.  But *its* permissions/ownership did not
> change!  So now I can't, for example,
>
>  $ echo x > /dev/stdout
>  bash: /dev/stdout: Permission denied
>
> which is quite unexpected - I for one expect /dev/stdout
> to work the way very similar to /dev/tty, to mean "current
> standard output regardless of any permissions etc".

This has nothing to do with /dev/stdout.  Your terminal simply does not
allow access by anyone except user root or group tty.  You need to open
it up first, or mount /dev/pts with broader permissions (which is a bad
idea however).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
