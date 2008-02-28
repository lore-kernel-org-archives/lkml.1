Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbYB1T0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbYB1T0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbYB1TZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:25:54 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756864AbYB1TZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:25:53 -0500
Date: Thu, 28 Feb 2008 11:24:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: kosaki.motohiro@jp.fujitsu.com, srostedt@redhat.com,
       Lee.Schermerhorn@hp.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@redhat.com,
       bob.picco@hp.com, eric.whitney@hp.com
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Message-Id: <20080228112423.fed6add2.akpm@linux-foundation.org>
In-Reply-To: <20080228191214.GA17872@elte.hu>
References: <20080227103831.423F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080227071118.GA4638@elte.hu>
	<20080228192509.BDCF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080228115041.GA22082@elte.hu>
	<20080228101343.1b9548e6.akpm@linux-foundation.org>
	<20080228191214.GA17872@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 20:12:14 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 28 Feb 2008 12:50:41 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > @@ -1000,7 +1001,7 @@ void release_console_sem(void)
> > >  	 * If we try to wake up klogd while printing with the runqueue lock
> > >  	 * held, this will deadlock.
> > >  	 */
> > > -	if (wake_klogd && !runqueue_is_locked())
> > > +	if (wake_klogd)
> > >  		wake_up_klogd();
> > >  }
> > 
> > I don't think we shoudl have added that hack in the first place.  It 
> > solves a problem which about three developers hit four times in five 
> > years but it has made kernel logging less reliable for everyone.
> 
> well, the problem was ia64, not a problem on x86 or other platforms.

I am referring to the original change which made klogd wakeups unreliable.
