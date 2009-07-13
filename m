Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZGMVog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZGMVog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZGMVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:44:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42668 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZGMVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=K97IIxH2LZExCJjxCIzKJe/9UOy26xkdW+kpaYbUBXZpK6BN+ecR7l4KjzyfIV8e/J
         HsH7uy352Q+w5ymnAk/ATLsBDejAEita73JbPZ/rITMN7uvtJHCS21oRW8m05QK5pl+s
         yVAewBAxrKzJaRn7LAK4pwm9XToelI5rFLW1k=
Message-ID: <4A5BAABF.9020708@gmail.com>
Date: Mon, 13 Jul 2009 23:44:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local>
In-Reply-To: <1247521235.7178.1.camel@johannes.local>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 11:40 PM, Johannes Berg wrote:
> On Mon, 2009-07-13 at 23:24 +0200, Jiri Slaby wrote:
>> Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
>> wl12xx_chip_wakeup fails).
> 
> By the way, are you using some tool to find these?

Yup, it's called stanse[1], but we still work on that to make it stable.

> I've had local hacks
> many times to make sparse aware of mutexes, is there a reason they are
> not annotated with __acquire(s)/__release(s) like spinlocks etc.?

Mutexes are often locked/unlocked interprocedural which I think sparse
can't do much about.

[1] http://iti.fi.muni.cz/stanse/
