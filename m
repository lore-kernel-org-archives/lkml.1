Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXLTTKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXLTTKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXLTTKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:10:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:48051 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbXLTTKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:10:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,191,1196668800"; 
   d="scan'208";a="346280806"
Message-ID: <476AB932.8050606@intel.com>
Date: Thu, 20 Dec 2007 10:49:22 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Parag Warudkar <parag.warudkar@gmail.com>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] e1000e: Use deferrable timer for watchdog
References: <Pine.LNX.4.64.0712182046560.3616@mini.warudkars.net>	 <476AA0C3.2080503@intel.com> <82e4877d0712200956l4126e221qc0cf4720e59ca2a1@mail.gmail.com>
In-Reply-To: <82e4877d0712200956l4126e221qc0cf4720e59ca2a1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Dec 2007 18:50:00.0446 (UTC) FILETIME=[1FB8C9E0:01C84339]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> On Dec 20, 2007 12:05 PM, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
>> I can't even apply this patch and the e1000 one... not only is it whitespace
>> damaged it is also not properly formatted as patch at all. If you want me to take
>> these patches seriously, then please fix the formatting issues.
> 
> Sigh - I use Pine, follow Documents/email-clients.txt for the
> recommended settings and obviously the pathces are not generated with
> whitespace damage at my end as I test those before sending out.
> 
> So although I hate to see this happen there is nothing at this moment
> that I can do - except for attaching the patch instead of inlining it.
> Since they have already been reviewed inline, please see if the
> attached patches work for you.

here's what the files in my Maildir spool look like in vim (my vim displays a '»'
char for tabs and a "¶" for EOL):

 76 --- linux-2.6/drivers/net/e1000e/netdev.c»      2007-12-07 10:04:39.00000000
 77 +++ linux-2.6-work/drivers/net/e1000e/netdev.c» 2007-12-18 20:45:59.00000000
 78 @@ -3899,7 +3899,7 @@¶
 79   »     »       goto err_eeprom;¶
 80   »     }¶
 81 ¶
 82 -»      init_timer(&adapter->watchdog_timer);¶
 83 +»      init_timer_deferrable(&adapter->watchdog_timer);¶
 84   »     adapter->watchdog_timer.function = &e1000_watchdog;¶
 85   »     adapter->watchdog_timer.data = (unsigned long) adapter;¶
 86 ¶
 87 --¶

notice that there are two spaces instead of 1. Also there's no line heading the
diff with 'diff a/foo b/foo' which is what throws of stg. And the -p option is
missing.


as for content, the patch looks OK with me. I ran the numbers and allthough there
was a slight average delay in the link up detection time it is negligeable (less
than 0.2sec difference over a bunch of measurements), and I confirmed your
powertop numbers are correct. As for the timer interval, the watchdog may already
be delayed up to 3 seconds safely, this doesn't change that.

I'll forward the patch, Care to make one for e100? plenty of laptops with those
still around! The embedded guys would love it I think.

Thanks,

Auke

