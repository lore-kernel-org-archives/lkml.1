Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZG1Vqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZG1Vqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZG1Vql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:46:41 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:58176 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZG1Vqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=undhifMfzswVvugirGbKHvIX/PKeOHZ3eG48UfSTCOR9yBohTaIhgZ1+SaoEtufx83
         BXW3BQCEGa4XevNKTABUAwquVyOmxw4IxGWxgujQYxRXso7VQjel2eaJyy9ZdKfmPSsR
         7zvNXpVc8Bk2qcJ7L9xoueouI+EuyWhszdeWY=
MIME-Version: 1.0
In-Reply-To: <4A69C03E.3090706@lih.rwth-aachen.de>
References: <4A69C03E.3090706@lih.rwth-aachen.de>
Date: Tue, 28 Jul 2009 14:46:39 -0700
X-Google-Sender-Auth: b32c9cef4bcb0a8b
Message-ID: <1f1b08da0907281446j685bcdf0i10975628e07ed1f8@mail.gmail.com>
Subject: Re: clock freezes??
From: john stultz <johnstul@us.ibm.com>
To: =?ISO-8859-1?Q?Victor_Matar=E9?= <matare@lih.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 7:07 AM, Victor Mataré<matare@lih.rwth-aachen.de> wrote:
> I have a dual Xeon server (old Xeon HT) with an Intel E7505 chipset,
> with hrtimer and dynticks enabled. On bootup, the kernel
> (2.6.29-gentoo-r5) tells me it's using the PM-Timer bug workaround, but
> then it uses tsc as clocksource. Now the clock was running slow for
> about 15sec/12hrs, which is quite a lot. So in a careless moment, I just
> tried "echo jiffies > clocksource0/current_clocksource". This froze the
> system time. Now I couldn't switch back to tsc or acpi_pm, echoing those
> was just ignored. Subsequently, the entire system locked up and I needed
> to reboot.
>
> Now what does that mean? Is this supposed to happen? Should I disable
> dynticks and/or hrtimer?

The system lockup is a known issue and should be resolved with the
following commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3f68535adad8dd89499505a65fb25d0e02d118cc

I might be curious if you could expand a bit more about the clock skew
(15sec per 12 hours) you're seeing. Are you running NTP? Do you have
the output of ntpdc -c kerninfo , ntpdc -c peers? Do you see lots of
ntp messages in /var/log/messages or /var/log/syslog ?

thanks
-john
