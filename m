Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYAIARn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYAIARn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYAIARe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:17:34 -0500
Received: from simmts6-srv.bellnexxia.net ([206.47.199.164]:54043 "EHLO
	simmts6-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbYAIARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:17:32 -0500
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 19:17:32 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAMKhg0ecIvL+/2dsb2JhbAAIqV8
Message-ID: <47841296.8090104@gmail.com>
Date: Tue, 08 Jan 2008 20:17:26 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com, gorcunov@gmail.com, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org> <47840C57.6000304@gmail.com> <20080109000946.GG2117@one.firstfloor.org>
In-Reply-To: <20080109000946.GG2117@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Jan 08, 2008 at 07:50:47PM -0400, Kevin Winchester wrote:
>> Andi Kleen wrote:
>>> Here's a proposal for some useful code transformations the kernel janitors
>>> could do as opposed to running checkpatch.pl.
>>>
>> <snip>
>>
>> I notice that every driver in drivers/ata uses a .ioctl that points to
>> ata_scsi_ioctl().  I could add the BKL to that function, and then change
> 
> This might be a little more complicated. These
> are funnelled through the block/SCSI layers which might not have separate
> unlocked ioctl callbacks yet. Would be probably not very difficult
> to add though.
> 
>> all of the drivers to .unlocked_ioctl, but I assume this would be a
>> candidate to actually clean up by determining why the lock is needed and
>> removing it if necessary.  Does anyone know off-hand the reason for
>> needing the lock (I assume someone does or it wouldn't have survived
>> this long)?  If the lock is absolutely required, then I can write the
>> patch to add lock_kernel() and unlock_kernel().
> 
> Just sending the patch to add lock/unlock_kernel() is probably a good idea anyways --
> Jeff will then feel bad over it and eventually remove it when he figures out
> it is safe ;-)
> 

Sorry about the noise here - I now notice that not all .ioctl function
pointers have the option of changing to .unlocked_ioctl.  In this case,
the ioctl is in the struct scsi_host_template, rather than struct
file_operations.

I'll try to be a little more careful about the git grepping in the future.

-- 
Kevin Winchester
