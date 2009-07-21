Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZGUJKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZGUJKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZGUJKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:10:22 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40624 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZGUJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=GCPqYtPImOfaMZMX+8zCQL239bXWpkGT/FyaaaZ9WQEfN8OurMkIPPINwuL/Ttocxz
         jxJTV2cyRjl5DGQ2K96W201xbFg1vMz6h/cBVCh4PImaU6/1qOdTFDFVC4/YUuUlpa0p
         /uUg9E1htNss9fhn2/htoivp9r3llYwV2kUHI=
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, luciano.coelho@nokia.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wireless: wl12xx, fix lock imbalance
References: <1247603833-10862-1-git-send-email-jirislaby@gmail.com>
	<87eish56zj.fsf@litku.valot.fi> <4A64E199.70501@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 21 Jul 2009 12:10:14 +0300
In-Reply-To: <4A64E199.70501@gmail.com> (Jiri Slaby's message of "Mon\, 20 Jul 2009 23\:28\:57 +0200")
Message-ID: <877hy2qu4p.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> But currently I'm confused by wl1251_plt_start and wl1251_plt_stop.
> They take a lock but doesn't unlock it at all. Neither their callies.
> Is it hidden somewhere deeper?

I guess that's a bug which creeped in when I ported the patches from our
internal tree. I'll just remove plt start/stop functions altogether,
they need to ported to the new nl80211 test mode interface anyway.

Oh damn, I just noticed that I added wl1251_netlink.c accidentally to
wireless-testing tree. It should definitely not be there, instead we
need to use nl80211 test command interface. I'll send a patch to remove
the private netlink stuff soon. John, sorry about this.

-- 
Kalle Valo
