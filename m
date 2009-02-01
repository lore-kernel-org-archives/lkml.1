Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZBAEPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZBAEPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 23:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBAEPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 23:15:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:45122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZBAEPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 23:15:24 -0500
Message-ID: <498521B8.1020703@kernel.org>
Date: Sun, 01 Feb 2009 13:14:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org> <49851507.5040905@garzik.org>
In-Reply-To: <49851507.5040905@garzik.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Feb 2009 04:14:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

Jeff Garzik wrote:
> But the net result is that you are telling dmraid that it is OK to
> proceed, even though part of the disk it wants is really missing.  That
> seems unwise, because are you not basically proceeding with a known
> corrupt dataset at that point?

Can you elaborate a bit?  I don't really understand what you mean.  To
clarify...

* What happens now.

BIOS sets up HPA expecting the raid driver to look at the metadata
which is at fixed offset from the end of the HPA locked size.  dmraid
doesn't know about it so looks at the wrong place.  Results can be
failed assembly or corrupt assembly depending on what's actually on
the disk.

* With the patches applied.

BIOS does the same but libata tells dmraid the BIOS size.  dmraid
looks at the same offset as the BIOS and everything is well.

Thanks.

-- 
tejun
