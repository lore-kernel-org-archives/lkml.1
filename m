Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYCMSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYCMSG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYCMSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:06:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54545 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYCMSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:06:17 -0400
Date: Thu, 13 Mar 2008 19:06:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080313180647.GD4949@elf.ucw.cz>
References: <20080312150042.96668bcd.akpm@linux-foundation.org> <20080313092813.GA24027@elf.ucw.cz> <20080313122823.GA19415@linux-mips.org> <20080313141917.GA4117@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313141917.GA4117@linux-mips.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 14:19:17, Ralf Baechle wrote:
> On Thu, Mar 13, 2008 at 12:28:23PM +0000, Ralf Baechle wrote:
> 
> > Looks correct to me, thus ACK.
> > 
> > Spinning that a little further I wonder how useful the rest of the
> > Alchemy code - which seems to only deal with devices - is.  If at all.
> > I'm going to check with some Alchemy users if that code actually works or
> > can be removed.  I think the latter.  Also there is the APM emulation
> > available which provides similar functionality.
> 
> So here a patch do cleanup a part.  Probably more to come
> 
> From: Ralf Baechle <ralf@linux-mips.org>
> 
> [MIPS] Alchey: Crapectomy after removal of pm_send_all calls.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

ACK.

> 
>  arch/mips/au1000/common/power.c |   20 --------------------
>  1 file changed, 20 deletions(-)
> 
> Index: linux-mips/arch/mips/au1000/common/power.c
> ===================================================================
> --- linux-mips.orig/arch/mips/au1000/common/power.c
> +++ linux-mips/arch/mips/au1000/common/power.c
> @@ -283,18 +283,6 @@ static int pm_do_sleep(ctl_table * ctl, 
>  	return 0;
>  }
>  
> -static int pm_do_suspend(ctl_table * ctl, int write, struct file *file,
> -			 void __user *buffer, size_t * len, loff_t *ppos)
> -{
> -	if (!write) {
> -		*len = 0;
> -	} else {
> -		suspend_mode = 1;
> -	}
> -	return 0;
> -}
> -
> -
>  static int pm_do_freq(ctl_table * ctl, int write, struct file *file,
>  		      void __user *buffer, size_t * len, loff_t *ppos)
>  {
> @@ -408,14 +396,6 @@ static int pm_do_freq(ctl_table * ctl, i
>  
>  static struct ctl_table pm_table[] = {
>  	{
> -		.ctl_name 	= CTL_UNNUMBERED,
> -		.procname	= "suspend",
> -		.data		= NULL,
> -		.maxlen		= 0,
> -		.mode		= 0600,
> -		.proc_handler	= &pm_do_suspend
> -	},
> -	{
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "sleep",
>  		.data		= NULL,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
