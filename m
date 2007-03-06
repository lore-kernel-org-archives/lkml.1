Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXCFIv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXCFIv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXCFIv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:51:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:38754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911AbXCFIv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:51:58 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: ebuddington@wesleyan.edu,
       "list, USB" <linux-usb-devel@lists.sourceforge.net>
Subject: Re: khubd and ent:sda1 sucking CPU with reiser4 + USB HD
Date: Tue, 6 Mar 2007 09:52:02 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20070306041337.GA9198@pool-71-123-121-36.spfdma.east.verizon.net>
In-Reply-To: <20070306041337.GA9198@pool-71-123-121-36.spfdma.east.verizon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703060952.02291.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 6. März 2007 05:13 schrieb Eric Buddington:
> reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
> WARNING: Flushing like mad: 16384
> reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
> WARNING: Flushing like mad: 32768
> ...<many simiar messages>
> 
> Most problematically, khubd and ent:sda1! are conspiring to suck 100%
> CPU time, even after powering off the drive. A bunch of processes are
> stuck in 'D' state, possibly because they're trying to access the dead
> disk, which won't umount ("device is busy").

It looks like khubd allocates memory and enters reiser4. Possibly we have
GFP_KERNEL in khubd where we should have GFP_NOIO or reiser4 has
a problem dealing with IO failures.

	Regards
		Oliver

