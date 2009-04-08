Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbZDHPAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbZDHPAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762412AbZDHO7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:59:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42986 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbZDHO7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:59:52 -0400
Message-ID: <49DCBBE2.4050506@garzik.org>
Date: Wed, 08 Apr 2009 10:59:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49DCB5A5.7040100@rtr.ca>
In-Reply-To: <49DCB5A5.7040100@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Matthew Wilcox wrote:
>> From: David Woodhouse <David.Woodhouse@intel.com>
>>
>> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>> [modified to reduce amount of special casing needed for discard]
>> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>> ---
> ..
>> +    task->tf.command = ATA_CMD_DSM;
>> +    task->tf.feature = ATA_DSM_TRIM;
>> +    task->tf.hob_feature = 0x00;
>> +    task->tf.nsect = size / 512;
>> +    task->tf.hob_nsect = (size / 512) >> 8;
> ..
> 
> Matthew (or others),
> 
> Could you perhaps explain what the purpose of the data portion
> of this command is for?  The draft ATA spec I have here has mangled
> text in the description -- like it's missing a crucial sentence there.
> 
> So it's not obvious exactly why this command even needs data to
> be transfered.

It's a list of LBA ranges, like the NV-cache stuff recently added.

	Jeff



