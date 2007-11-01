Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbXKAPHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbXKAPHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbXKAPHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:07:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:23338 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436AbXKAPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=o4OtWRROGCqCk4uyayTppyWx15GWQgoIlen/psKyuK7GEx6q/sq5zusFk0S/MgCgrdkm1oCafL7v4cr6ljFWVWwyrVFXkvHohRSJslmH+9FgP6/F/++7d8x3+5v+Kv29Rv9C78/D70Ru5UzOurM39OXCA0iLvmOLS5M+DOKYvow=
Message-ID: <4729EBA5.3080907@gmail.com>
Date: Thu, 01 Nov 2007 16:07:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Char: tty, add tty_schedule_wakeup
References: <15530290543226725036.slaby@karneval.cz> <4729E3F3.2090602@microgate.com>
In-Reply-To: <4729E3F3.2090602@microgate.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum napsal(a):
> Jiri Slaby wrote:
>> + *    Functionally the same as tty_wakeup, but it can be used in hot
>> + *    paths. since the wakeup is scheduled and done in the future.
>>
> 
> I'm not familiar with the terminology 'hot paths',
> what do you mean by that?

Ah, thank you for the feedback, I should change this, since it seems to be
not so much descriptive.

Functionally the same as tty_wakeup, but it can be used in code, which is
expected to be fast and short (e.g. interrupt handler), since the wakeup is
scheduled and done in the future.

> Do you have an example of where you intend to
> use this new facility? The patch does not include
> such an example so it is difficult for me to see
> why you are adding this function.

I want to use it in all char drivers, which schedules a work only for
tty_wakeup() calling, because they don't want to include more code in
interrupt handlers for example (if I understand the code correctly, e.g.
n_tty discipline may invoke whole fasync machinery on tty_wakeup call).

If somebody thinks it's not needed (or it's overkill), the other approach
comes -- change all wakeup schedules with simple tty_wakeup().

thanks.
