Return-Path: <linux-kernel-owner+w=401wt.eu-S1762468AbYB1TNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762468AbYB1TNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762092AbYB1TMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:12:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761230AbYB1TMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:12:38 -0500
Date: Thu, 28 Feb 2008 20:12:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Message-ID: <20080228191214.GA17872@elte.hu>
References: <20080227103831.423F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080227071118.GA4638@elte.hu> <20080228192509.BDCF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080228115041.GA22082@elte.hu> <20080228101343.1b9548e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228101343.1b9548e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 28 Feb 2008 12:50:41 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > @@ -1000,7 +1001,7 @@ void release_console_sem(void)
> >  	 * If we try to wake up klogd while printing with the runqueue lock
> >  	 * held, this will deadlock.
> >  	 */
> > -	if (wake_klogd && !runqueue_is_locked())
> > +	if (wake_klogd)
> >  		wake_up_klogd();
> >  }
> 
> I don't think we shoudl have added that hack in the first place.  It 
> solves a problem which about three developers hit four times in five 
> years but it has made kernel logging less reliable for everyone.

well, the problem was ia64, not a problem on x86 or other platforms. The 
problem here is ia64 not setting up percpu data structures soon enough. 
It has blown up in the past in other areas, and it will likely blow up 
in the future in other areas as well. It's just not robust to have init 
dependencies on such basic data structures like percpu areas like that.

	Ingo
