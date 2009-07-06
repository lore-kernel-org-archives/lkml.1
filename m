Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZGFUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZGFUd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZGFUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:33:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:30039 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbZGFUdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s9qZyfj4ahTaB4CUUSGdF5y8HWhaIoRnHiCCjX36lOdUrDR6PFuWM1OxprEqpfWPn1
         9wYQLG/qmCbYgVJkocxkZu8YNgyLG/F7Cx/reoX6WnpqOSp3G3ZuYFA3inHAOdu1bQUp
         2jA8IqZwMPXAcpz/aVBBGyHFCl/ajWVmSJ5ec=
Message-ID: <4A525FA8.80509@gmail.com>
Date: Mon, 06 Jul 2009 16:33:44 -0400
From: "Alan D. Brunelle" <adbrunelle@gmail.com>
Reply-To: Alan.Brunelle@pobox.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Jens Axboe <jens.axboe@oracle.com>, scameron@beardog.cca.cpqcorp.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
References: <20090702082313.F3754D340B@pentland.suse.de>
In-Reply-To: <20090702082313.F3754D340B@pentland.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Reinecke wrote:
> When doing an unexpected shutdown like kexec the cciss
> firmware might still have some commands in flight, which
> it is trying to complete.
> The driver is doing it's best on resetting the HBA,
> but sadly there's a firmware issue causing the firmware
> _not_ to abort or drop old commands.
> So the firmware will send us commands which we haven't
> accounted for, causing the driver to panic.
> 
> With this patch we're just ignoring these commands as
> there is nothing we could be doing with them anyway.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Pardon my ignorance here, but don't you have a bigger problem: if the 
reset is not dropping or aborting old commands, doesn't this also mean 
that these old commands can still be _executing_? In which case any 
(old) reads being executed could be scribbling over memory? (Memory that 
may be being used for other purposes?)

Alan D. Brunelle

