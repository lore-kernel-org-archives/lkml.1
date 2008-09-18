Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYIRXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYIRXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYIRXJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:09:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:8210 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbYIRXI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:08:59 -0400
Message-ID: <f488382f0809181608y3e9fc530k3e770488985e9fe9@mail.gmail.com>
Date: Thu, 18 Sep 2008 16:08:57 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080918220102.GE7408@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 3:01 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>> If I do, I'll need to know what precisely to do about it. What debug
>> info should I collect before rebooting?
>
> Sure, OK so in ath9k's core.h we have a macro used to indicate what
> type of debugging stuff gets print out. By default we only leave
> enabled the fatal stuff.
>
> #define DBG_DEFAULT (ATH_DBG_FATAL )
>
> You want to add to this ATH_DBG_INTERRUPT as follows:
>
> #define DBG_DEFAULT (ATH_DBG_FATAL | ATH_DBG_INTERRUPT)
>
> Then since the issue seems to come up when you rmmod, simply try to
> download do some large RXing or TXing or both and then rmmod. Capture
> the output and send along.

Will do! And actually, to be precise, the issue occurred not on the
rmmod, but on the following modprobe for ath9k.

>> Which is far more important, I agree. It's annoying to get speeds
>> <802.11b on my pre-802.11n capable chipset and network. ;)
>
> Yeah exactly, I hope the work we do will get in for 27. We'll see.

Linus has been fairly strict lately, so I am as uncertain as you are.
It really should get merged, because having 2.6.27 with [partially]
broken wireless networking is kind of stupid. In the worst case, isn't
it possible to do a revert to get the old aggregation crap back in?
