Return-Path: <linux-kernel-owner+w=401wt.eu-S1765146AbYEGVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765146AbYEGVSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYEGVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:18:06 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:28679 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbYEGVSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ttJn/Jx5mARiaEaz6swkHzKI/iD15Bf53CCBNt6wOARWvvaL2ThvMS4ra1OAGI44S6oLNwjclwT8WT8rzFDlDj5xNxmUQCDDCUg4KDCF3kl47JTZuRf0NoE9sUHEmAoyd6fMe68elmitdU05Y6bUghKk29esmUf1FdhirEy8cfQ=
Message-ID: <1f1b08da0805071418q365680bexafb1996dcc77ebb0@mail.gmail.com>
Date: Wed, 7 May 2008 14:18:01 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [RFC][PATCH 1/4] RTC: Class device support for persistent clock
Cc: "Alessandro Zummo" <a.zummo@towertech.it>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
X-Google-Sender-Auth: 590bf975fa113a09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 5:40 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>  This is a generic implementation of rtc_read_persistent_clock() and
>  rtc_update_persistent_clock() suitable for platforms to be used for
>  read_persistent_clock() and update_persistent_clock() calls.  An RTC
>  device selected by the user with the RTC_HCTOSYS_DEVICE option is used.
>
>   As rtc_read_persistent_clock() is not available at the time
>  timekeeping_init() is called, it will now be disabled if the class device
>  is to be used as a reference.  In this case rtc_hctosys(), already
>  present, will be used to set up the system time at the late initcall time.
>  This call has now been rewritten to make use of
>  rtc_read_persistent_clock().

Hrmm. So how is this going to work with suspend and resume?

Ideally, on resume we want to update the clock before interrupts are
reenabled so we don't get stale time values post-resume.  For systems
that sleep on reading the persistent clock, I'm open to having them
fix it up as best they can later (partly why the code can handle
read_persistent_clock() not returning anything), but unless I'm
misreading this, it seems you're proposing to make systems that do
have a safe persistent clock have to have the window where code may
see the pre-suspend time after resume.

Am I missing something here?

thanks
-john

Maciej: Sorry for the dup, I forgot to reply to all on my first mail.
