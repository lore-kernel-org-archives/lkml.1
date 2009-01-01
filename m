Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZAAFKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZAAFKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 00:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbZAAFK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 00:10:28 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:56827 "EHLO
	smarthost1.samage.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbZAAFK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 00:10:28 -0500
Message-ID: <57128.124.177.22.144.1230786624.squirrel@secure.greenhost.nl>
In-Reply-To: <20081229122449.GG9628@elte.hu>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl>
    <1230536044-14847-1-git-send-email-indan@nul.nu>
    <20081229122449.GG9628@elte.hu>
Date: Thu, 1 Jan 2009 06:10:24 +0100 (CET)
Subject: Re: [PATCH] Fix race in ring_buffer_consume(): Replace 
     ring_buffer_consume and ring_buffer_peek with ring_buffer_get_event
From: "Indan Zupancic" <indan@nul.nu>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Steven Rostedt" <srostedt@redhat.com>, "Ingo Molnar" <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -0.1
X-Scan-Signature: 9090f8a1960d7f777b94d17b6f36e747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, December 29, 2008 13:24, Ingo Molnar wrote:
>
> * Indan Zupancic <indan@nul.nu> wrote:
>
>> Original mail was mangled, patch resent via git.
>>
>> Signed-off-by: Indan Zupancic <indan@nul.nu>
>> ---
>>  include/linux/ring_buffer.h   |    4 +---
>>  kernel/trace/ring_buffer.c    |   39
>> ++++++++-------------------------------
>>  kernel/trace/trace.c          |   15 ++++++++-------
>>  kernel/trace/trace_selftest.c |    2 +-
>>  4 files changed, 18 insertions(+), 42 deletions(-)
>
> there's been a number of updates here - could you please do a patch
> against tip/master:
>
>   http://people.redhat.com/mingo/tip.git/README

Thanks for that readme, now I discovered git remote, which is not
mentioned often enough for some reason.

A lot changed indeed, most importantly the race that I hit is
fixed in tip by improved locking. Replace ring_buffer_consume()
and ring_buffer_peek() with ring_buffer_get_event() or not is
just a matter of taste now. Are you still interested in such a
patch?

(34 EXPORT_SYMBOL_GPLs in ring_buffer.c seems a bit excessive though.)

Greetings,

Indan


