Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbYKXJvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbYKXJvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYKXJuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:50:51 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:2101 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYKXJuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b7qZiDLGrPRzn2iNhLHLOTe6k0+O6sEe7dCWfR42b7Xu47y0QGyFx0q3bKBjQRazy8
         0Asgii4zxGnpthvAR257OEAKJ6lFKox3SX9JUpBbwFYfSMFtbQHzrhjReom9Ux+iVbWD
         Ht0FmHgMMs/Hd9zJAwNvQCs8R3lBtEw8PHaIs=
Message-ID: <492A78F4.9050007@gmail.com>
Date: Mon, 24 Nov 2008 11:50:44 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] __used is needed for function referenced only from inline
 asm
References: <1227514662-10848-1-git-send-email-edwintorok@gmail.com> <20081124090403.GA25218@elte.hu>
In-Reply-To: <20081124090403.GA25218@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-24 11:04, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> According to the gcc manual, the 'used' attribute should be applied to
>> functions referenced only from inline assembly.
>> This fixes a build failure with llvm-gcc-4.2, which deleted
>> __mutex_lock_slowpath, __mutex_unlock_slowpath.
>>
>> Signed-off-by: Török Edwin <edwintorok@gmail.com>
>> ---
>>  kernel/mutex.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>     
>
> quite sad - it's gcc inline assembly after all - applied to 
> tip/core/locking (for v2.6.29).

Thanks.

>  Should this get into v2.6.28 too?
>   

It is up to you to decide. I'd say it can't hurt to have it in 2.6.28,
and patch looks trivial enough.

On the other hand it is not urgent either, building a full x86 kernel
with llvm-gcc only still has some loose ends
(there is something wrong with the boot code for example, like it can't
detect vga modes, I didn't figure out what is wrong yet)

Best regards,
--Edwin
