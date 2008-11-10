Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYKJCHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYKJCHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 21:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYKJCHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 21:07:37 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:45970 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYKJCHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 21:07:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Rva839tnxMpbU0h4PEjUW0mwyqmMWbRkb6dfxASi9OaG859WJvZUT13e0bj/9lBqKv
         o7Oq57W6SRjFSyRZQLVA64AiI7hvG4hpURs8k2gvP8MxhlbG+TQ79wOXZUcOM4XeFtgr
         nPf9+PYFurTTAiFLyfRozgOgGZZDRFmxzkpcg=
Message-ID: <386072610811091807i6f24d765l89323998ab7d6d40@mail.gmail.com>
Date: Mon, 10 Nov 2008 10:07:34 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video driver.
Cc: linux-uvc-devel@lists.berlios.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <200811091355.05074.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225963052-6657-1-git-send-email-cooloney@kernel.org>
	 <200811091355.05074.laurent.pinchart@skynet.be>
X-Google-Sender-Auth: ae28f433d3f76799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 9, 2008 at 8:55 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> Hi Bryan, Michael,
>
> Thanks for the patch.
>
> On Thursday 06 November 2008, Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> buffer can be odd aligned on some NOMMU machine such as Blackfin
>
> The comment is a bit misleading. Buffers can be odd-aligned independently off
> the machine type. The issue comes from machines that can't access unaligned
> memory. Something like "Fix access to unaligned memory" would be better.
>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/media/video/uvc/uvc_driver.c |   37
>> +++++++++++++++++---------------- 1 files changed, 19 insertions(+), 18
>> deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_driver.c
>> b/drivers/media/video/uvc/uvc_driver.c index d7ad060..9b4f469 100644
>> --- a/drivers/media/video/uvc/uvc_driver.c
>> +++ b/drivers/media/video/uvc/uvc_driver.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/videodev2.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/wait.h>
>> +#include <asm/unaligned.h>
>>  #include <asm/atomic.h>
>>
>>  #include <media/v4l2-common.h>
>> @@ -432,20 +433,20 @@ static int uvc_parse_format(struct uvc_device *dev,
>>
>>               frame->bFrameIndex = buffer[3];
>>               frame->bmCapabilities = buffer[4];
>> -             frame->wWidth = le16_to_cpup((__le16 *)&buffer[5]);
>> -             frame->wHeight = le16_to_cpup((__le16 *)&buffer[7]);
>> -             frame->dwMinBitRate = le32_to_cpup((__le32 *)&buffer[9]);
>> -             frame->dwMaxBitRate = le32_to_cpup((__le32 *)&buffer[13]);
>> +             frame->wWidth = le16_to_cpu(get_unaligned((__le16 *) &buffer[5]));
>
> What about using get_unaligned_le16 and get_unaligned_le32 directly ? Lines
> would be shorter and could be kept behind the 80 columns limit more easily.
>
> Tell me if you want to resubmit or if I should make the modification myself
> (including the patch description).
>

I guess Michael will update this patch according to you review. Then
we will resubmit it.

Thanks a lot
-Bryan
