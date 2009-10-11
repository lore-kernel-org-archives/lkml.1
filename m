Return-Path: <linux-kernel-owner+w=401wt.eu-S1751009AbZJKUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbZJKUMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZJKUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:12:46 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35969 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZJKUMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AAMSA1zjJi+E2DX1vizNcX7NtYQw6hDgBtD0oLKP9u4scC9rf395D/bNJUR6eLj4Qa
         Pir7dDFXiPbhEq/9/TqaLSQt0eSvtGh7dHR+oqEfhLT43z6pmQ0zM4IKIgBZqHvO0tTB
         LfssHAoaO4IkBmDTTh5Wsq2th2NUKSldl4AGQ=
Message-ID: <4AD23C17.4010201@gmail.com>
Date: Sun, 11 Oct 2009 14:12:07 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
CC: stable@kernel.org
Subject: Re: [PATCH] scsi: properly export media change notification capability
   in block device flags
References: <4AD237E3.6000206@gmail.com>
In-Reply-To: <4AD237E3.6000206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2009 01:54 PM, Robert Hancock wrote:
> Due to some oversight, the SCSI capability for reporting media change
> notifications was never actually translated into setting the appropriate
> GENHD_FL_MEDIA_CHANGE_NOTIFY flag. HAL uses this flag to detect whether the
> block device supports change notifications and so it never actually got
> detected. Set the flag when appropriate in sd and sr.
>
> Signed-off-by: Robert Hancock<hancockrwd@gmail.com>
>
> ---
>
> Gaah, am I disappointed in finding this one. Apparently people went to the
> trouble of adding ATAPI AN support, and adding the appropriate flags to indicate
> to userspace that it was supported, but nobody ever tested to make sure that
> the support worked all the way through to actually make HAL stop polling
> optical drives that support AN, which to my dismay, it doesn't. In fact even
> with this patch it still doesn't seem to, but that's presumably some HAL bug.
> HAL does now report that storage.removable.support_async_notification = true,
> however.

To follow up on the above, from what I can see from the HAL code, it has 
code to detect the capability from sysfs and set its flag, but there's 
no code to actually disable polling based on the flag. Seems like plenty 
of epic fail to go around on this one :-)
