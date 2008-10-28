Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYJ1BNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYJ1BNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYJ1BM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:12:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:54849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYJ1BMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:12:55 -0400
Message-ID: <490666D6.8090603@kernel.org>
Date: Tue, 28 Oct 2008 10:11:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mike Anderson <andmike@linux.vnet.ibm.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Timeout regression introduced by	242f9dcb8ba6f68fcd217a119a7648a4f69290e9
References: <49043C7C.8050207@kernel.org> <1225034105.3958.4.camel@localhost.localdomain> <49051EA4.3040403@kernel.org> <20081027213006.GB17946@linux.vnet.ibm.com>
In-Reply-To: <20081027213006.GB17946@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Oct 2008 01:11:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Anderson wrote:
> Tejun Heo <tj@kernel.org> wrote:
>> James Bottomley wrote:
>>> On Sun, 2008-10-26 at 18:46 +0900, Tejun Heo wrote:
>>>> Hello, Jens.
>>>>
>>>> Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
>>>> regression for libata.  The second timeout gives puts different
>>>> pointer from the issued command onto eh_cmd_q breaking libata EH
>>>> command matching which triggers WARN_ON() in ata_eh_finish() and hangs
>>>> command processing or causes oops later depending on circumstances.
>>>>
>>>> Here are logs with induced timeouts (patch attached).  In commit
>>>> 242f9dcb8, the XXX messages for the second timeout shows different
>>>> scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
>>>> ata_scsi_qc_new() during command translation.
>>> I can't see a way we could be getting a different command passed in from
>>> the actual one, since the only way to lose the command from the request
>>> is to go through the command completion routines which free it (and end
>>> the request).
>> I have no idea either.  It's something in the timeout logic because on
>> the issue path the scmd pointer is identical but on tiemout pointer
>> for another scmd is queued on eh_cmd_q, which doesn't make much sense.
>>
> 
> I was trying to recreate this error using ata_ram wth v2.6.28-rc2.
> Currently I am not able to see this error on timeout recovery using this
> setup. Does IO load (or other factors) effect the error being seen?

Not at all.  That's the only write command I issued.

-- 
tejun
