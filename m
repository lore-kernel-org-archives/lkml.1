Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYLZSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYLZSV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYLZSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:21:51 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32791 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbYLZSVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:21:50 -0500
Date: Fri, 26 Dec 2008 13:21:45 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andreas Sundstrom <sunkan@zappa.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Message-ID: <20081226182145.GP9871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Sundstrom <sunkan@zappa.cx>, linux-kernel@vger.kernel.org
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4954FB62.4090306@zappa.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm... ok, to summarize, you are seeing this problem with 2.6.28 (have
you tried earlier kernel versions) when an LVM volume has a read/only
snapshot in existence and you try to mount the LVM volume using ext4.
If you mount the same LVM volume using ext3, you don't see any
problems.   Is that correct?

Can you try mounting ext3 with barriers enabled?  Booting with the
command linux option rootflags=barriers should do the trick.  If that
fails, then it would indicate that trying to enable barriers in a Xen
guest while the host OS has created a snapshot of volume causes an I/O
error, thus leading errors which you are seeing.

						- Ted
