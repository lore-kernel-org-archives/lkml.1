Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZE3P0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZE3P0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 11:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbZE3P0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 11:26:16 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:60901 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZE3P0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 11:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=eu4xxaMCp2IfuE00CXCuY4rVAFDyBCcBh5C7VDwwNCaC2lII/ReMWe6lAyOogXYIOO
         igPhPLCvPf7GhWCQi5diingHn4m0wRKo6yMus4hslgaheXZz5nBBmcJODV0MiTzE+yo1
         5kxlTfiDPwqy0t3XrflfjZWvIwVTlhwawTdV4=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <1243638870.13863.1.camel@johannes.local>
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
	 <200905260124.03287.tobias.doerffel@gmail.com>
	 <1243294366.29222.10.camel@johannes.local>
	 <200905300033.12204.tobias.doerffel@gmail.com>
	 <1243638870.13863.1.camel@johannes.local>
Date: Sat, 30 May 2009 16:26:13 +0100
Message-ID: <9b2b86520905300826q3eeab9cdjf575d98c7aca9ad2@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: added initial RFKILL support
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2009-05-30 at 00:33 +0200, Tobias Doerffel wrote:
>
>> > Could you try to work against v11
>> > of my rfkill patch, or better even against the cfg80211 rfkill instead?
>> I didn't look at both of them yet. However I think we first should try to
>> get
>> current rfkill support into mainline as fast as possible. Improvements and
>>
>> adaptations to reworked rfkill framework can follow.
>
> No other comments from me -- but since the v11 of the rfkill rewrite
> will certainly hit the tree before your patch (it's almost in) you
> _will_ have to work against it. I'll also try to make the cfg80211
> rfkill hit the tree very soon for reasons I'll explain elsewhere -- you
> would be better off working against that because then your rfkill code
> is very very very simple and doesn't need to do much at all.
>
> johannes

Btw, I believe the new rfkill core behaviour should avoid the concern
I raised about the EeePC.

Reminder: the eeepc-laptop implements platform rfkill on the original
model(s) by hotplugging the entire ath5k device.  If you boot with it
in the blocked state, the old rfkill core would "lock in" that state
as the default.  If you then hotplug the ath5k device _and it comes up
with an rfkill device of it's own_, my concern is that the new rfkill
device would be initialized to a blocked state.  It would be
impossible to enable the wireless.

The new core removes this idea of a separate "default" state, so it
can't have this problem.

Regards
Alan
