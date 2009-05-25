Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZEYSPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZEYSPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 14:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZEYSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 14:15:09 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:52546 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZEYSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 14:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LGHTXnhjs5Vavep9dI///kIepTE17Lqb8zvZ6i7kTj1ctTqo8uJ8EdCVA2NmcGcHNP
         dVWpB6xFc5OzmBq9kYdHVkAitnvGVWpMwWxkaASY7QFa/xOsgCjV6sUecTMId89HCeFy
         PtRnRmCqZpHeLUIw+tfBz3rMznf4y3h/ROJco=
Message-ID: <4A1AE02D.5080701@gmail.com>
Date: Mon, 25 May 2009 20:15:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com> <4A1AC5A3.9000600@gmail.com> <20090525172033.GA12586@redhat.com>
In-Reply-To: <20090525172033.GA12586@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2009 07:20 PM, Oleg Nesterov wrote:
> On 05/25, Jiri Slaby wrote:
>> If the poll isn't there, it works well.
> 
> Hmm. this is strange. Do you mean that if this program does
> sleep(10000) (or something else) instead of poll() above, it
> prints pend != 0 ?

No, only when there is nothing, i.e. when it directly calls close. It's
consistent with what you wrote. When there is sleep(), it works the same
as the poll case.

> And. Why do you need fatal_signal_pending() ? It is special,
> should be used by things like wait_event_killable().

I need to wait for a device to finish its work in last release, but also
want to allow user to kill the waiting by SIGKILL if he thinks the
device locked up (this is pretty usual for that particular device). If I
use wait_event_killable, I end up with this.

Well, there is a STOP ioctl and a user should catch sigterm/int/quit and
call that ioctl and bail out. But users are weird and get unkillable
processes.

Anyway thanks for the clarification.
