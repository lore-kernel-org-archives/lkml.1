Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZHTIwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZHTIwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZHTIwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:52:46 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63317 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZHTIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qxGjAHFscJzBhhIfgAY035x0g2rNeo/WnYe+NwHmHrugXRelhc4PTj8lu6mhYZfinH
         JyDsYbNVyv3DFavB2/QKQyQBxMLZUajxqoIKa47t95c0BUDQjQ7QP4PID2YIosYKsSkw
         KZvNLqcRSs4wJNtUCRmg/uHZILaKNcNyqRa4s=
MIME-Version: 1.0
In-Reply-To: <4A8C48BA.1000009@dell.com>
References: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com>
	 <1250707376.8073.4.camel@johannes.local> <4A8C48BA.1000009@dell.com>
Date: Thu, 20 Aug 2009 09:52:44 +0100
Message-ID: <9b2b86520908200152m28daa816ib8c54a423e63ca1a@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, cezary.jackiewicz@gmail.com,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Johannes:
>
> Johannes Berg wrote:
>> On Wed, 2009-08-19 at 13:36 -0500, Mario Limonciello wrote:
>>
>>
>>
>>
>> Isn't that missing sysfs_remove_group()?
>>
>> johannes
>>
> The third patch in the (updated) series is dropping the sysfs bits, so
> sysfs_remove_group is removed there.

That's not ideal.  Each patch should stand on its own; it's bad form
to introduce a bug in one patch and fix it in the next one.  Even
something obscure like omitting to free the sysfs group when
setup_rfkill() fails.

I would suggest merging these two patches into one. That would avoid
adding sysfs_remove_group() in this patch, just to remove it in the
next one.  It also avoids the question in this patch, of what happens
to the rfkill interface if you write to the sysfs file.

Alan
