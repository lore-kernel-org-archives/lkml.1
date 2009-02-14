Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbZBNUZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbZBNUZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZBNUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:25:21 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:57980 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZBNUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x7xpo5Ohx05iVm3kEE/VCd6h8s+2DhddmPehq4hjlwAde0RPqq/ra4gt5RNyNltQ9y
         +Y+rvQArcHyVLMWj2laMY4Ax9OaZ3UGHSOu5y4FsK6wP6DthoZHuoTO6HXnBy5kZd7YJ
         HDr9ioofe93fITDUaZPnOkMAmqXbHCh+A6FUA=
Message-ID: <499728AC.90609@gmail.com>
Date: Sat, 14 Feb 2009 21:25:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: lenb@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 1/1] x86_64: fix s3 fail path
References: <1234190120-6268-1-git-send-email-jirislaby@gmail.com> <200902142121.46987.rjw@sisk.pl>
In-Reply-To: <200902142121.46987.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Monday 09 February 2009, Jiri Slaby wrote:
>> As acpi_enter_sleep_state can fail, take this into account in
>> do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
>> caller. This would break (currently) fpu status and preempt count.
>>
>> Technically, this means use `call' instead of `jmp' and `jmp' to
>> the `resume_point' after the `call' (i.e. if
>> acpi_enter_sleep_state returns=fails). `resume_point' will handle
>> the restore of fpu and preempt count gracefully.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: Pavel Machek <pavel@suse.cz>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> 
> What kernel is this patch against?  It doesn't apply to the mainline.

It is applicable even after
[PATCH v2 1/1] x86_64: acpi/wakeup_64 cleanup
from
http://lkml.org/lkml/2009/2/7/101
which is not present anywhere so far.
