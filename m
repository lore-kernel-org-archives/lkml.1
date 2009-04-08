Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbZDHOoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbZDHOoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZDHOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:44:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:63234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZDHOoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Eh7I6V8Vsmgs/MoONH/cEMv93XxC1IZC+nhSNb8ocBoiWssj72rwGULCmhgW97n4kh
         nTvHJbdKS3dpYdkmb4X2Q4qMDcoFqeg7SB4rGyoZSTiEgv4VW7BYbIaJEPRROVGs6Ecu
         9Rtc9r1lezoXFJaiNufTmOuYVjB5g8By/Ggr4=
MIME-Version: 1.0
In-Reply-To: <49DCB5A5.7040100@rtr.ca>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
	 <1238683047-13588-2-git-send-email-willy@linux.intel.com>
	 <1238683047-13588-3-git-send-email-willy@linux.intel.com>
	 <1238683047-13588-4-git-send-email-willy@linux.intel.com>
	 <49DCB5A5.7040100@rtr.ca>
Date: Wed, 8 Apr 2009 23:44:04 +0900
Message-ID: <7fe698080904080744y15f781b9lc71d84e705ef6089@mail.gmail.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
From: Dongjun Shin <djshin90@gmail.com>
To: Mark Lord <liml@rtr.ca>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 11:33 PM, Mark Lord <liml@rtr.ca> wrote:
>
> Matthew Wilcox wrote:
>>
>> From: David Woodhouse <David.Woodhouse@intel.com>
>>
>> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>> [modified to reduce amount of special casing needed for discard]
>> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>> ---
>
> ..
>>
>> +       task->tf.command = ATA_CMD_DSM;
>> +       task->tf.feature = ATA_DSM_TRIM;
>> +       task->tf.hob_feature = 0x00;
>> +       task->tf.nsect = size / 512;
>> +       task->tf.hob_nsect = (size / 512) >> 8;
>
> ..
>
> Matthew (or others),
>
> Could you perhaps explain what the purpose of the data portion
> of this command is for?  The draft ATA spec I have here has mangled
> text in the description -- like it's missing a crucial sentence there.
>
> So it's not obvious exactly why this command even needs data to
> be transfered.

It's for transfering list of LBA ranges which composed of
LBA offset (48bit) and length of data to be trimmed (16bit).

--
Dongjun
