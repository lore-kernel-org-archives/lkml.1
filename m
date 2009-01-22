Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZAVPOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZAVPOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZAVPOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:14:46 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:43122 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZAVPOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:14:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=My23uRSZH9zvpE2xuosogrjcSF7zr0T1qMjIJdDNJzImheKnwltTXChMCol+oKtz2Q
         +fPoVI0wMIshppN5VXBR8N2mxJfp0XNtJHmaCNi96b0dDqex3pg31+GJwBOgPdLuDE/Z
         ApzTgmJSgEZlEjTTRaMvT1YU7h7h0adCDRDk4=
MIME-Version: 1.0
In-Reply-To: <20090120115500.GA4442@elte.hu>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <b647ffbd0901190841j785172e5n24d29511a2e61332@mail.gmail.com>
	 <20090119164440.GA20754@elte.hu> <200901192025.37711.rjw@sisk.pl>
	 <c4e36d110901191431j62168b4yaf8a4ffdbbe38bea@mail.gmail.com>
	 <20090119234905.GC452@elte.hu>
	 <c4e36d110901200241x487092e9na0cda704de666d2b@mail.gmail.com>
	 <c4e36d110901200348n4009800dyebaf932039babf30@mail.gmail.com>
	 <20090120115500.GA4442@elte.hu>
Date: Thu, 22 Jan 2009 16:14:42 +0100
Message-ID: <c4e36d110901220714j524343c5k2673d5626aef2460@mail.gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/20 Ingo Molnar <mingo@elte.hu>:
>
> (Cc:-ed Johannes Berg)
>
> * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>
>> With network enabled - the error is back - thus it might be a bug in
>> ieee80211 stack ??
>
> yes, the crash implicates the ieee80211 stack [ieee80211_stop() in
> net/mac80211/iface.c]:
>
>> general protection fault: 0000 [#1] SMP
>> RIP: 0010:[<ffffffff8053ce01>]  [<ffffffff8053ce01>] wait_for_common+0x131/0x190
>> Process NetworkManager (pid: 2265, threadinfo ffff88006b508000, task
>> Call Trace:
>>  [<ffffffff8025a735>] synchronize_rcu+0x35/0x40
>>  [<ffffffff8025a620>] ? wakeme_after_rcu+0x0/0x10
>>  [<ffffffff8053ce3f>] ? wait_for_common+0x16f/0x190
>>  [<ffffffff8024b424>] ? local_bh_enable+0xa4/0x110
>>  [<ffffffff804c8ce1>] ? dev_deactivate+0x151/0x1d0
>>  [<ffffffff804b750d>] ? dev_close+0x6d/0xd0
>>  [<ffffffffa016b042>] ? ieee80211_stop+0x562/0x570 [mac80211]
>>  [<ffffffffa016ab59>] ? ieee80211_stop+0x79/0x570 [mac80211]

Any progress with this problem ?

Btw - I've tried your branch   tip-latest
(52a4061e1d88ad242c8022f68df3686c3bc05159)
 - and this branch now resets my machine during resume. (it suspends -
auto-wake-up and reboots)
 - so it this branch actually suggested to be used/tested ?

Zdenek
