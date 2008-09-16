Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYIPDtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYIPDtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 23:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYIPDtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 23:49:15 -0400
Received: from rtr.ca ([76.10.145.34]:43262 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYIPDtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 23:49:14 -0400
Message-ID: <48CF2CBF.2050406@rtr.ca>
Date: Mon, 15 Sep 2008 23:49:19 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
References: <20080911193511.7960bc82@neptune.home> <48CE22E5.9090403@kernel.org> <48CEC5FB.4040503@rtr.ca> <48CEC76E.7020101@kernel.org>
In-Reply-To: <48CEC76E.7020101@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>..
> Hmm.. most of FLUSH timeouts I've seen are either a dying drive or bad
> PSU.  There just isn't much which can go wrong from the driver side.
> IIRC, there was a problem when the unused part of TF is not cleared
> but that was the only one.
> 
>> Smartctl output is clean (no logged errors), and the drives themselves
>> are fine after a reboot -- necessary since libata/scsi kicked the drive out
>> of the RAID array.
>>
>> Something strange is going on here.
> 
> Any chance you can trick the client to hook up the drive to a separate PSU?
..

No, the failures happen randomly at customer sites, and only since they
"upgraded" to SLES10 with libata.  I think the PSUs are probably just fine.

Time to hack the drivers to give proper status on the timeouts, too;
otherwise we won't ever have any clue as to what is really happening.

Cheers
