Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYIOUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYIOUjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYIOUir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:38:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYIOUip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:38:45 -0400
Message-ID: <48CEC76E.7020101@kernel.org>
Date: Mon, 15 Sep 2008 13:37:02 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
References: <20080911193511.7960bc82@neptune.home> <48CE22E5.9090403@kernel.org> <48CEC5FB.4040503@rtr.ca>
In-Reply-To: <48CEC5FB.4040503@rtr.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Sep 2008 20:38:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>> Timeout on FLUSH_EXT.  That's a bad sign.  Patch to retry FLUSH is
>> pending but at any rate FLUSH failure is often accompanied by loss of
>> data and XFS is doing the right thing of giving up on it.
> ..
> 
> Tejun, are we *sure* that's really a timeout?
> The status shows 0x40 "drive ready" there, aka. "command complete".

Heh... on timeout, libata EH doesn't touch status register as some
controllers lock the whole machine up on that, so the 0x40 is just the
fill value libata used during qc initialization.  It definitely
requires clarification.

> I have a client who is also seeing this exact scenario on 750GB drives,
> using a patched SLES10 kernel (2.6.16 + libata from 2.6.18 or so).

Hmm.. most of FLUSH timeouts I've seen are either a dying drive or bad
PSU.  There just isn't much which can go wrong from the driver side.
IIRC, there was a problem when the unused part of TF is not cleared
but that was the only one.

> Smartctl output is clean (no logged errors), and the drives themselves
> are fine after a reboot -- necessary since libata/scsi kicked the drive out
> of the RAID array.
>
> Something strange is going on here.

Any chance you can trick the client to hook up the drive to a separate
PSU?

Thanks.

-- 
tejun
