Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYAJNK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYAJNK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYAJNKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:10:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:4932 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYAJNKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GGj7Ink6XVnGcTErMj8qIP/k45V5EqSVDo7mwEqqcCkTI4JtNwXtbLYyzWC65rZEcTattAI5cFoqfElSR/TIatgLE+4ilxFOWCisQQxRB875ZnJN0PrUK27ADA8BHrOGDqIqJH5XVGv+JpatJyrDZzFFIswGAZKPXOevuXe7xjU=
Message-ID: <47861930.7010708@gmail.com>
Date: Thu, 10 Jan 2008 22:10:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>	<20080108015012.2e518dd4@werewolf>	<478429B2.2030002@gmail.com> <20080110102505.62097da1@werewolf>
In-Reply-To: <20080110102505.62097da1@werewolf>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

J.A. Magallón wrote:
> It reproduces also with 2.6.23.13.
> Finally I think the problematic disk is sdc:

Okay, then, it's less likely a regression and more likely a newly
developed hardware problem.

> ICH5 PATA -> sda
> ICH5 SATA0 -> sdb
> ICH5 SATA1 -> sdc
> Promise SATA -> sdd
> 
> The problem is that even I have commented out the entry for sdc in fstab,
> the system is still giving me errors. An my guess is that errors in sdc makes
> the ICH5 sata controller go nuts, and then I get errors also in sdb.
> Just a couple questions...

I've never seen ICHs or any other SATA controllers act that way.

> - Can I say to ata_piix something like 'please, detect first SATA ports before
>   ATA', so my system disk (sdb) becomes sda ?

You do that using LABEL, UUID or device ID.  Just run 'ls -l
/dev/disk/by-*/' and see the result.

> - Can I say 'plz, ignore port 1', so it does not try to detect/start/spin sdc ?
>   So I ban be sure it is the one to blame, before start to remove hardware...

Unfortunately not but you can boot into single mode where there's
nothing trying to access the disk without your explicit command and
verify access to each hard disk.

Hmm... You are seeing timeouts from multiple harddisks.  The first thing
I would try is to reseat the cables and connect the SATA hard drives to
a separate power supply and see whether that changes anything.

-- 
tejun
