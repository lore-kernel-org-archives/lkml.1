Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZC2NPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZC2NPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZC2NPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:15:31 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:58823 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbZC2NP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DRwxjct5wfJ/tXus96fq6n3wuJwUWWriqcixz9VF3AqfcMhH56/8CPqS1h3yOGHpwU
         37NdCvPlD8B8COCqyZCjO7op19zAew+JtOpZ+T77NOBgqpTG3Qje75vxKeH1v9GEthKX
         c3/OUs9+lnycMYqBZ0XbBrx6qjZQ3wiR1bh3g=
MIME-Version: 1.0
In-Reply-To: <49CF4161.6080401@msgid.tls.msk.ru>
References: <87tz5ckfye.fsf@burly.wgtn.ondioline.org>
	 <49CF316D.6040903@gmail.com> <87prg0k8kd.fsf@burly.wgtn.ondioline.org>
	 <49CF4161.6080401@msgid.tls.msk.ru>
Date: Sun, 29 Mar 2009 09:15:24 -0400
Message-ID: <b6c5339f0903290615p5d7d7041nd5e5b5a584ef9bae@mail.gmail.com>
Subject: Re: soft lockup apparently in ath5k_hw_update_mib_counters (or 
	ioread32?) with 2.6.29
From: Bob Copeland <bcopeland@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Paul Collins <paul@burly.ondioline.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 5:37 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Paul Collins wrote:
>>
>> Jiri Slaby <jirislaby@gmail.com> writes:
>>
>>> On 03/29/2009 08:20 AM, Paul Collins wrote:
>>>>
>>>> After about two days of uptime with 2.6.29 I got this:
>>>>
>>>> BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
>>> Huh. I see no reason for this to happen. I suppose this is a regression,
>>> which kernel worked?
>>
>> I had a previous instance of the problem with v2.6.29-rc8 after about
>> six days of uptime.  The kernel before that was 2.6.29-rc7ish, ran OK
>> for a couple of days.  But since I don't know how to reproduce it
>> reliably it's hard to say which kernel is truly good.

I think it's just an interrupt storm because we don't reset MIB
interrupts properly (I think not all devices are read-and-clear).  I
already have a patch in wireless-testing to turn off MIB interrupts until
ANI is working and I CCed stable on it.

http://marc.info/?l=linux-wireless&m=123725924404147&w=2

-- 
Bob Copeland %% www.bobcopeland.com
