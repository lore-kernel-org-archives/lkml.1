Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYKCOSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYKCOSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYKCORs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:17:48 -0500
Received: from emulex.emulex.com ([138.239.112.1]:45618 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbYKCORr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:17:47 -0500
Message-ID: <490F0822.6010406@emulex.com>
Date: Mon, 3 Nov 2008 09:18:10 -0500
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with the block-layer timeouts
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org> <20081103085247.GO31673@kernel.dk>
In-Reply-To: <20081103085247.GO31673@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2008 14:18:14.0724 (UTC) FILETIME=[02875040:01C93DBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> While I'm on the subject, there are a few related items that could be
>> improved.  In my tests, I was generating I/O requests simply by doing
>>
>>       dd if=/dev/sda ...
>>
>> I don't know where the timeouts for these requests are determined, but
>> they were set to 60 seconds.  That seems much too long.
> 
> Fully agreed, as Mike mentioned this actually looks like a dumb udev
> rule that didn't have any effect until this generic timeout work. For
> normal IO, something in the 10 second range is a lot more appropriate.

Yes and no. For direct-attach storage with no other initiators, ok. But 
for larger arrays, potentially with multiple initiators - no.  I can 
name several arrays that depend on a 30 second timeout, and a few that, 
underload, require 60 seconds.  I assume that there's usually "best 
practices" guides for the integrators to ensure the defaults are set right.

-- james s
