Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYCCKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYCCKKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYCCKKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:10:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:54183 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbYCCKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:10:29 -0500
From: Andreas Schwab <schwab@suse.de>
To: Gabriel Paubert <paubert@iram.es>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] add strncmp to PowerPC
References: <1204301097.14759.6.camel@localhost.localdomain>
	<1204340690.15052.457.camel@pasglop>
	<Pine.LNX.4.58.0802292250490.21555@gandalf.stny.rr.com>
	<20080303095443.GB27105@iram.es>
X-Yow: Bo Derek ruined my life!
Date: Mon, 03 Mar 2008 11:10:27 +0100
In-Reply-To: <20080303095443.GB27105@iram.es> (Gabriel Paubert's message of
	"Mon\, 3 Mar 2008 10\:54\:43 +0100")
Message-ID: <je4pbow224.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel Paubert <paubert@iram.es> writes:

> Now that I think a bit more about it, I believe that the C version is
> incorrect: the clrldi/extsb dance takes a value between -255 and +255
> and collapses it into the -128 to 127 range, meaning that the return
> value may be wrong if we rely on the sign of the result. So unless I
> miss something, the problem is much more serious than just stupid code
> (I had just a look at the libc version in C and characters are cast to
> unsigned char before the comparison).

The latter is explicitly required by the C standard.  Ie. even if your
characters are signed they are always compared as unsigned by
strcmp/strncmp/memcmp.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
