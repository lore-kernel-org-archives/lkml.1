Return-Path: <linux-kernel-owner+w=401wt.eu-S932751AbYD2S4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbYD2S4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbYD2S4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:56:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:42812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbYD2S4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:56:04 -0400
Date: Tue, 29 Apr 2008 11:55:43 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [27/37] tehuti: move ioctl perm check closer to function start
	(CVE-2008-1675)
Message-ID: <20080429185543.GA24643@suse.de>
References: <20080429171222.073929148@mini.kroah.org> <20080429171901.GB14724@suse.de> <20080429191310.203384eb@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429191310.203384eb@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 07:13:09PM +0100, Alan Cox wrote:
> On Tue, 29 Apr 2008 10:19:01 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > know.
> > 
> > ------------------
> > From: Jeff Garzik <jeff@garzik.org>
> > 
> > Commit f946dffed6334f08da065a89ed65026ebf8b33b4 upstream
> > 
> > Noticed by davem.
> > 
> > Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/net/tehuti.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > --- a/drivers/net/tehuti.c
> > +++ b/drivers/net/tehuti.c
> > @@ -649,6 +649,9 @@ static int bdx_ioctl_priv(struct net_dev
> >  		DBG("%d 0x%x 0x%x\n", data[0], data[1], data[2]);
> >  	}
> >  
> > +	if (!capable(CAP_NET_ADMIN))
> > +		return -EPERM;
> > +
> 
> Should be CAP_SYS_RAWIO

Hm, that's the way it is in Linus's tree, we should change it there
first.

thanks,

greg k-h
