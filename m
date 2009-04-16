Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZDPET6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZDPET6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 00:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZDPETu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 00:19:50 -0400
Received: from thunk.org ([69.25.196.29]:37891 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZDPETt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 00:19:49 -0400
Date: Thu, 16 Apr 2009 00:19:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090416041945.GK21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Price <andy@andrewprice.me.uk>, linux-kernel@vger.kernel.org
References: <20090415205926.GA28246@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415205926.GA28246@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 09:59:26PM +0100, Andrew Price wrote:
> Using rootfstype=ext4 with today's linux-2.6.git causes a panic on my
> two amd64 machines (haven't tested it on any others). 

Hmm, git commit id, please?  The stack traces are in the IDE interrupt
handler, so it seems surprising that ext4 would trigger it but ext3
would not.  Have you tried ext4 on any earlier kernel?

The main difference I can think of is that ext4 enables barriers by
default; maybe that's the case of the IDE breakage?  Can you try
booting with the boot command option "rootfsflags=barrier=0" as well
as "rootfstype=ext4", and see if that helps?

If so, it's a bug in the IDE code in that it's not handling barriers
correctly.

						- Ted
