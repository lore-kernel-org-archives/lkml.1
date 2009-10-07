Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbZJGQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbZJGQQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbZJGQQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:16:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbZJGQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:16:52 -0400
Date: Wed, 7 Oct 2009 12:16:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Pittman <daniel@rimspace.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed
	s2disk/ram cycle
Message-ID: <20091007161604.GA28849@infradead.org>
References: <1254863215.11577.23.camel@maxim-laptop> <200910062358.32417.rjw@sisk.pl> <20091006225329.GA27646@khazad-dum.debian.net> <200910070102.47293.rjw@sisk.pl> <20091007012930.GA7022@khazad-dum.debian.net> <87vdisq7bh.fsf@rimspace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdisq7bh.fsf@rimspace.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 01:14:10PM +1100, Daniel Pittman wrote:
> For what it is worth, I would also be quite interested to know /why/ XFS is
> bad in this regard.  Is it just the previously stated "XFS writes to disk
> despite freezing kernel threads" issue, or something deeper?

sync pushes out all data to disk, but in a journaling filesystem that
might just but the log not the "normal" place on disk.  For a boot
loader to deal with it properly it actually needs to do an replay of
the log.  Grub does so for reiserfs but not for XFS for some reason.
I don't know why problems don't trigger more often with ext3, though.
