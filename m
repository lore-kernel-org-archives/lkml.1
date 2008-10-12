Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYJLLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYJLLPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYJLLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:15:45 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:44404 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYJLLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:15:44 -0400
Message-ID: <f488382f0810120415k5fa80a0x328a4b0c450b1fd5@mail.gmail.com>
Date: Sun, 12 Oct 2008 04:15:42 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] cifs: fix build on !CONFIG_KEYS
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steve French" <sfrench@us.ibm.com>,
       "Jeff Layton" <jlayton@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <f488382f0810120414s3c119df5i7737f0ae7304527c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081012110904.GA581@elte.hu> <200810121317.07372.rjw@sisk.pl>
	 <f488382f0810120414s3c119df5i7737f0ae7304527c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, which fix is correct though? Depending on KEYS in Kconfig, or
adding a nop for it?

- Steven

On Sun, Oct 12, 2008 at 4:14 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> Dang it. I got to this one late. I literally -just- fixed it locally.
>
> - Steven
>
> On Sun, Oct 12, 2008 at 4:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Sunday, 12 of October 2008, Ingo Molnar wrote:
>>>
>>> hi,
>>>
>>> find a quick build fix for CIFS below - you might have it already.
>>> Please double-check.
>>
>> Heh, I've just sent another fix for the same issue. :-)
>>
>> Thanks,
>> Rafael
>>
>>
>>> ----------->
>>> From 9d65371d47bc0285a557f279d402764f73551d3c Mon Sep 17 00:00:00 2001
>>> From: Ingo Molnar <mingo@elte.hu>
>>> Date: Sun, 12 Oct 2008 13:01:52 +0200
>>> Subject: [PATCH] cifs: fix build on !CONFIG_KEYS
>>> MIME-Version: 1.0
>>> Content-Type: text/plain; charset=utf-8
>>> Content-Transfer-Encoding: 8bit
>>>
>>> CIFS has keys infrastructure dependencies:
>>>
>>>   fs/cifs/sess.c: In function 'CIFS_SessSetup':
>>>   fs/cifs/sess.c:628: error: implicit declaration of function 'key_revoke'
>>>
>>> So express that dependency in the Kconfig.
>>>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  fs/Kconfig |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/Kconfig b/fs/Kconfig
>>> index 40183d9..c0eade5 100644
>>> --- a/fs/Kconfig
>>> +++ b/fs/Kconfig
>>> @@ -1876,6 +1876,7 @@ config SMB_NLS_REMOTE
>>>  config CIFS
>>>       tristate "CIFS support (advanced network filesystem, SMBFS successor)"
>>>       depends on INET
>>> +     depends on KEYS
>>>       select NLS
>>>       help
>>>         This is the client VFS module for the Common Internet File System
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
