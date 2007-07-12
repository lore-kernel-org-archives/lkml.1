Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbXGLK2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbXGLK2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbXGLK17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:27:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51430 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbXGLK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:27:58 -0400
Message-ID: <46960225.5000502@garzik.org>
Date: Thu, 12 Jul 2007 06:27:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dave@thedillows.org
Subject: Re: [RFT][PATCH v7] sata_mv: convert to new EH
References: <20070711200538.GA7374@havoc.gtf.org> <Pine.LNX.4.64.0707120212210.25837@twinlark.arctic.org>
In-Reply-To: <Pine.LNX.4.64.0707120212210.25837@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> On Wed, 11 Jul 2007, Jeff Garzik wrote:
> 
>> As before, this patch is against 2.6.22 with no other patches needed nor
>> applied.
>>
>> In this revision, interrupt handling was improved quite a bit,
>> particularly for EDMA.  The WARNING in mv_get_crpb_status() goes away,
>> because that routine went away.  Its EDMA handling was potentially racy
>> as well.  It was replaced with a loop in mv_intr_edma() that guarantees
>> it always clears responses out of the queue, not a single response.
>>
>> Here's hoping that the WARNING in mv_qc_issue() goes away as well, but I
>> am less than 50% confident that will happen.
>>
>> The driver is making substantial progress with all these improvements,
>> though, in searching for the cause of this hardware behavior :)
>>
>> Though if mv_qc_issue() still warns, I would be interested to know if
>> this driver works OK if the mv_qc_issue() warning is simply removed at
>> that point...
> 
> oh very nice... no warnings on boot, and no warnings while i "dd 
> if=/dev/sdX of=/dev/null" and i'm seeing 74MB/s+ from each disk on this 
> simple read test.
> 
> for lack of a better test i started an untar/diff stress test on the 
> disks... we'll see how it goes.  (it's based on doug ledford's 
> memtest.sh)

Thanks for the testing.  Looks like we might have hit on something good...

	Jeff



