Return-Path: <linux-kernel-owner+w=401wt.eu-S965907AbXC2CHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907AbXC2CHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 22:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934302AbXC2CHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 22:07:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:24712 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973AbXC2CHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 22:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MPEkEE/+gmk9G+dTZsP702IevrBRT5OZwtNe7JAXTPmlUTOVE5vogU/6N79o2YuEtMTY35f3ey2okZdclPulv7+te5i4oL4yGdil/TGG8lKVBFLkfJXRv5Ji6VHaN9YE4CArtherzrCN5WyZXjgDXzjqjadj4YxONeyxI7L02Sc=
Message-ID: <460B1F6B.5050108@gmail.com>
Date: Thu, 29 Mar 2007 11:07:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [patch 2/3] libata: expose AN support to user space via sysfs
References: <20070328230108.597741522@intel.com> <20070328164450.b89d5156.kristen.c.accardi@intel.com> <460B0539.9040103@pobox.com>
In-Reply-To: <460B0539.9040103@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Kristen Carlson Accardi wrote:
>> Allow user space to determine if an ATAPI device supports
>> async notification (AN) of media changes.  This is done by
>> adding a new sysfs file "async_notification" to genhd.
>> If the file reads 1, then the device supports async notification.  If 
>> the file reads 0, it does not. 
>> A flag is set in the generic disk to indicate whether
>> or not AN is supported.  This flag is set by the SCSI
>> subsystem when it registers with add_disk.  The SCSI
>> system gets information from libata on whether the
>> device supports AN during dev_configure.
>> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>>
> 
> 3) I would make the contents of 'media_change_events' be a list of 
> flags, rather than a boolean.  Thus, when AN is present, 
> media_change_events would return "AN\n".  It would return "\n" (no 
> flags) when AN is absent.  This permits future expansion of this 
> capabilities reporting variable.

I'm not sure about this.  AN is kind of specific term for ATA while 
media change event is generic.  So, I think the original approach is 
okay.  No matter how the actual thing is implemented, it's the same 
media change event and as long as event delivery interface is the same, 
upper layer shouldn't care about how it's done.

Thanks.

-- 
tejun
