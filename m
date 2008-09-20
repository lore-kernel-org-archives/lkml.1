Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYITU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYITU5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYITU5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:57:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:55795 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYITU5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FYxRI9X2ktZ44l3zEvNB9k1X9Hu75g76y0tNhdRSbC880nMylaGuF03Z9jNyHw1uPe
         UKRGK2cgyROsUKqVEEJZ5AfQstTggvNyqJ3j/EObT1VmYEXTj7UAgYjjI9RQSK6uAcfr
         hTAKZRdhZ0ln5Fa3barGyuRgDMCvTRwJtKD0k=
Message-ID: <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
Date: Sat, 20 Sep 2008 13:57:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
X-Google-Sender-Auth: 1499fd18415d603a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 8:21 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Fri, Sep 19, 2008 at 8:29 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> And here's the change as I unload and reload ath9k:
>>
>> [...]
>> 20:21:38          sum  20138.83
>> 20:21:40          sum  21576.09
>> 20:21:41          sum  17678.38
>> 20:21:42          sum  19834.34
>> 20:21:43          sum  19845.10
>> 20:21:44          sum  19470.00
>> 20:21:45          sum   9273.00  <--- ath9k unloaded/reloaded
>> 20:21:46          sum    187.00
>> 20:21:47          sum   1066.00
>> 20:21:48          sum    610.00
>> 20:21:49          sum    106.93
>> 20:21:50          sum    670.00
>> 20:21:51          sum    742.00
>> 20:21:52          sum    781.00
>> Average:          sum  19562.56
>>
>
> I think it might help if you can see the .sar file yourself. I've
> uploaded a gzipped copy (great compression ratio in this case for
> merely using gzip!).
>
> http://www.uplinklabs.net/~tycho/linux/irqlog-storm.sar.gz

mcgrof@tesla ~/tmp/irq $ sar -f irqlog-storm.sar -A
Invalid system activity file: irqlog-storm.sar

Perhaps we its a different format than what my sar can read...

So here's what we need to do -- try to zero on in what causes this IRQ
storm. Most likely its some strange event that triggers it, perhaps
some sort of noise which makes the device try to adapt and hits a path
we are not handling correctly yet. Can you provide the initial log of
when ath9k gets loaded? This tells us what card it is, like AR5416 or
AR9280, etc.

  Luis
