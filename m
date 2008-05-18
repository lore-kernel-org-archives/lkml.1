Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYEREp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYEREp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 00:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYEREpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 00:45:16 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61317 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750875AbYEREpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 00:45:14 -0400
Date: Sun, 18 May 2008 05:39:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: john stultz <johnstul@us.ibm.com>
cc: Alessandro Zummo <a.zummo@towertech.it>, Jean Delvare <khali@linux-fr.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/4] RTC: Class device support for persistent clock
In-Reply-To: <1f1b08da0805071418q365680bexafb1996dcc77ebb0@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0805160356570.519@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
 <1f1b08da0805071418q365680bexafb1996dcc77ebb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

 Sorry about the delay -- I have missed your comment in the flood.

On Wed, 7 May 2008, john stultz wrote:

> >   As rtc_read_persistent_clock() is not available at the time
> >  timekeeping_init() is called, it will now be disabled if the class device
> >  is to be used as a reference.  In this case rtc_hctosys(), already
> >  present, will be used to set up the system time at the late initcall time.
> >  This call has now been rewritten to make use of
> >  rtc_read_persistent_clock().
> 
> Hrmm. So how is this going to work with suspend and resume?

 Hmm, I have never used suspend/resume, so I cannot really comment.  Here
is what I gathered by glancing over the code and some bits of
documentation.

> Ideally, on resume we want to update the clock before interrupts are
> reenabled so we don't get stale time values post-resume.  For systems
> that sleep on reading the persistent clock, I'm open to having them
> fix it up as best they can later (partly why the code can handle
> read_persistent_clock() not returning anything), but unless I'm
> misreading this, it seems you're proposing to make systems that do
> have a safe persistent clock have to have the window where code may
> see the pre-suspend time after resume.

 Right now it looks the time is restored in two places, 
timekeeping_resume() and rtc_resume().  Of course once the transition to 
the new RTC infrastructure has been done, one is going to be redundant.  
For the time being I think it is harmless to have them both.

 That written, both are called from the relevant driver's ->resume()  
method.  My set of patches does not change it and as far as I can tell if
it worked before, it will work afterwards.  As I understand ->resume()  
methods may sleep and are called with interrupts already enabled.
 
> Am I missing something here?

 No idea -- anyone?

  Maciej
