Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYLDEMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYLDEMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLDEMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:12:34 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49285 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbYLDEMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:12:33 -0500
Date: Wed, 3 Dec 2008 23:10:16 -0500
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frederic Bohe <frederic.bohe@bull.net>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [patch 086/104] ext4: fix initialization of UNINIT bitmap
	blocks
Message-ID: <20081204041016.GA13887@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Frederic Bohe <frederic.bohe@bull.net>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20081203193901.715896543@mini.kroah.org> <20081203195618.GI8950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203195618.GI8950@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 11:56:18AM -0800, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.

Turns out this patch introduces a worse regression than it fixes.  The
bug that the patches fixes is that on-line resizes of filesystems with
a 1k blocksize will usually fail.  The regression is that when a
filesystem with 1k blocksize is stressed, the filesystem can get
corrupted.  On balance, on-line resizing failing is less of a disaster
than corrupting the filesystem when its stressed.  Fortunately, it's
only an issue when the filesystem blocksize is less than the page
size, which isn't the common case at least for the x86.  

There are patches queued up to address this, but they haven't hit
mainline yet.  Probably best to pull this from the stable tree for
now.

						- Ted
