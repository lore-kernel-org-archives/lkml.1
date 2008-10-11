Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbYJKRw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbYJKRw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbYJKRwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:52:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58780 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758211AbYJKRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:52:15 -0400
Date: Sat, 11 Oct 2008 18:51:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Snook <csnook@redhat.com>, Stefan Monnier <monnier@iro.umontreal.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081011185157.478ea357@lxorguk.ukuu.org.uk>
In-Reply-To: <20081011143552.GA1556@ucw.cz>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
	<48ED1D62.8080100@redhat.com>
	<20081011143552.GA1556@ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Writes to magnetic disks are functionally atomic at the sector level.

No they are not.

> I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
> if you write data 'nearby' root directory and power fails, bye bye
> filesystem, and journal will not help.

You have similar problems on rotating media. A write to a block can
corrupt other blocks adjacent to the block you write, and on the latest
disks the physical block size can be greater than the logical one so
unless you laid your partitions out right you have read-modify-write
cycles goin on.

Alan
