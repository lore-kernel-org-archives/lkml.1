Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYIZLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYIZLES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYIZLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:04:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:21157 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYIZLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mC1D54aYAZaPwA+x62tALdxcgQ+bwLlqzwXOHgImfz++U3QK1NuNpLhJYgE31lrb+X
         RkDXvlQ2XK5i/2FwPgFTAVY3PXTBFTWPi0zB6x13+f0lBN3PxIVqCsUYBPAuUA27UzK3
         2RHJ63VYcUQNVEVFeFRM/2uSAWS2FRPiK2TTo=
Message-ID: <48DCC18B.2060302@gmail.com>
Date: Fri, 26 Sep 2008 13:03:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: fix tty<->hid deadlock
References: <48BFFAE0.5010001@gmail.com>            <1220541367-10984-1-git-send-email-jirislaby@gmail.com> <3717.1220573006@turing-police.cc.vt.edu>
In-Reply-To: <3717.1220573006@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu napsal(a):
> On Thu, 04 Sep 2008 17:16:07 +0200, Jiri Slaby said:
> 
>> hid_compat_load() runs on the default workqueue, it request_module(), it
>> execs modprobe, it exits, tty flushes default workqueue, it hangs, because
>> we are still in it.
>>
>> I haven't run into it since there always was at least one opener of the tty,
>> I guess. Could you try the patch below?
>>
>> --
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>  drivers/hid/hid-core.c |   11 ++++++++++-
>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 92c16e1..18d952a 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
> 
> With this patch applied, the kernel behaves as expected for my config: it
> requests a 'modprobe hid_dummy', which prints a nasty message about being
> unable to find it on the initrd, and then we continue with the boot.

Thanks for testing, I can't think of any method which would solve this
problem. As this compat module is a temporary solution for those who have
(very) old module init tools (not supporting aliases), I wouldn't do
anything else until somebody complains.
