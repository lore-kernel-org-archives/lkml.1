Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYHPG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYHPG7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYHPG7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 02:59:06 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:54954 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYHPG7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 02:59:05 -0400
Message-ID: <39687.166.70.238.45.1218868509.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <87ljyxxybv.fsf@basil.nowhere.org>
References: <200808160341.m7G3flG1022571@wolfmountaingroup.com>
    <87ljyxxybv.fsf@basil.nowhere.org>
Date: Sat, 16 Aug 2008 00:35:09 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc3 21/28] mdb: disable console warnings if the 
     debugger is present.
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com writes:
>>
>>  /* Some debug stub to catch some of the obvious races in the VT code */
>> +
>> +#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
>> +#define WARN_CONSOLE_UNLOCKED()
>> +#else
>>  #if 1
>>  #define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() &&
>> !oops_in_progress)
>>  #else
>>  #define WARN_CONSOLE_UNLOCKED()
>>  #endif
>> +#endif /* CONFIG_MDB */
>
> The obvious alternative would be to just set oops_in_progress
> while the debugger runs.
>
> -Andi
>

Also added to the list.  that would remove the need for this patch, which
would also benefit kdb since it also has a similar patch in this file too.

I will roll these fixes into the rc4 patch.

Jeff


