Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZIYIQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZIYIQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZIYIQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:16:32 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:58453 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZIYIQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=klthxQSDHKtK9n0fDaorKab6zsa2fz7JuB4lNzmiYte2Pr6Qdlepg5GJAPBMM5uv3T
         ojmKXvvkbbwZCpgl1+CWR2pyzBCb2tZ3pVRf9JXZCZficF0Ovj5JwQGzhqWi8pV7iW2Y
         FFqDNGSdQI2Aqa3b9uvjjd1ZranR5EPoo31xE=
MIME-Version: 1.0
In-Reply-To: <1253825033-30094-1-git-send-email-linux@bohmer.net>
References: <1253825033-30094-1-git-send-email-linux@bohmer.net>
Date: Fri, 25 Sep 2009 10:16:22 +0200
X-Google-Sender-Auth: d2664353f2622f0e
Message-ID: <4de7f8a60909250116o69a52b09wbbeec340de4b7158@mail.gmail.com>
Subject: Re: [PATCH] get rid of [softirq-NULL]
From: Jan Blunck <jblunck@suse.de>
To: Remy Bohmer <linux@bohmer.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:43 PM, Remy Bohmer <linux@bohmer.net> wrote:
> if CONFIG_HIGH_RES_TIMERS is not configured, still the hrtimer-softirq
> is started, so to prevent the name 'softirq-NULL' in 'ps' output we
> should still define its name here.
> Preventing the softirq from starting at all would touch much more code, so
> I chose the easy way here, it is a cosmetic fix anyway.

Anyway, it would be the right thing to do just that.

Just un-define the enum HRTIMER_SOFTIRQ and the code that needs
modification should pop up. Removing it from the enum also disables
the kthread. Most of the code that raises the softirq should be
guarded by CONFIG_HIGH_RES_TIMERS anyway.

HtH,
Jan
