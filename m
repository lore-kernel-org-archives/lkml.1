Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZLSCor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZLSCor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 21:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZLSCoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 21:44:46 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49518 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbZLSCop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 21:44:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EDphvh0VGbwonjTjjOSUK6tIQ4WKpIn9lNobbbcmtgyM81sS8RfLMNyjzShaSiM4bG
         6FqZce5BxjTW5CBQMiJSy+LKkl7b/qfI0AWLAT6/gWeTrmaTVVRe7cq2qCnP6Sdd9zZk
         acYoF/Z78+92Ym9ruNOsWL16j0xVWq+iwwwAQ=
MIME-Version: 1.0
In-Reply-To: <200912181813.44220.sfking@fdwdc.com>
References: <200912181813.44220.sfking@fdwdc.com>
Date: Fri, 18 Dec 2009 18:44:44 -0800
X-Google-Sender-Auth: 224a9af184eeedd5
Message-ID: <1f1b08da0912181844u4f7e66a7ue30287208d075327@mail.gmail.com>
Subject: Re: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
From: john stultz <johnstul@us.ibm.com>
To: Steven King <sfking@fdwdc.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 6:13 PM, Steven King <sfking@fdwdc.com> wrote:
> Attach is the .config; it works on v2.6.32 but fails to boot on .33-rc1; but
> if I deselect hrtimers && tickless then it works.

Sorry for the dup, forgot to cc lkml on my reply.

Fails to boot all together? Or does it hang at some point in the dmesg
that you can point out?

Could you run the following so we can narrow down which clocksource your using?
cat /sys/devices/system/clocksource/clocksource0/current_clocksource
cat /sys/devices/system/clocksource/clocksource0/available_clocksource

Then with the kernel that doesn't boot, go through the clocksources
listed in available_clocksources and try booting w/
"clocksource=<clock name>" and see if the behavior changes.

thanks
-john
