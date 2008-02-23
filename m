Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYBWNTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYBWNTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYBWNTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:19:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9136 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbYBWNTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:19:07 -0500
X-SBRS: 2.8
X-MesageID: 43201547
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,394,1199682000"; 
   d="scan'208";a="43201547"
Date: Sat, 23 Feb 2008 14:10:28 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH2] Basic braille screen reader support
Message-ID: <20080223131028.GC4244@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
	Jiri Kosina <jkosina@suse.cz>
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080205165853.561d5f3d.akpm@linux-foundation.org> <20080206020423.GG4394@implementation> <20080222002822.GB32480@implementation> <20080223000410.674ce674.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080223000410.674ce674.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Sat 23 Feb 2008 00:04:10 -0800, a écrit :
> > +++ linux-2.6.24.1-perso/kernel/printk.c	2008-02-21 12:09:06.000000000 +0100
> > @@ -105,6 +105,7 @@
> 
> Please use `diff -p'

Argl, that's editdiff's fault.  We need to fix it to keep the -p
comments.

> >  	char	name[8];			/* Name of the driver	    */
> >  	int	index;				/* Minor dev. to use	    */
> >  	char	*options;			/* Options for the driver   */
> > +	char	*brl_options;			/* Options for braille driver */
> >  };
> 
> Should this depend on CONFIG_A11Y_BRAILLE_CONSOLE or whatever?

It can, indeed.  It just makes the code a little more clumsy to save 32
or 64 bytes.

> > +	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
> > +		if (strcmp(console_cmdline[i].name, name) == 0 &&
> > +			  console_cmdline[i].index == idx) {
> > +				if (!brl_options)
> > +					selected_console = i;
> > +				return 0;
> > +		}
> > +	if (i == MAX_CMDLINECONSOLES)
> > +		return -E2BIG;
> 
> Does the array of consles have any locking here?

Well, that's actually just the original code that I moved a bit earlier,
so the code path is not changed.

> > +	if (!brl_options)
> > +		selected_console = i;
> > +	c = &console_cmdline[i];
> > +	memcpy(c->name, name, sizeof(c->name));
> > +	c->name[sizeof(c->name) - 1] = 0;
> 
> strlcpy()?

Again, that's the original code, unmodified, but we can put an strlcpy
here yes.

> > +static void beep(unsigned int freq)
> > +{
> > +	if (sound)
> > +		kd_mksound(freq, HZ/10);
> > +}
> 
> hm, do we have enough Kconfig dependencies here to ensure that kd_mksound()
> is always available?

Ah, CONFIG_VT is needed indeed.

I'll address those in replies to this mail.

Samuel
