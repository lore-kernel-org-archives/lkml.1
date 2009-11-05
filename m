Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZKESQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZKESQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbZKESQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:16:26 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43845 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757270AbZKESQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:16:25 -0500
Date: Thu, 5 Nov 2009 12:16:28 -0600
From: Jack Steiner <steiner@sgi.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
Message-ID: <20091105181628.GA2239@sgi.com>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain> <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain> <200911051847.36103.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911051847.36103.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 06:47:33PM +0100, Michael Buesch wrote:
> On Thursday 05 November 2009 18:38:21 Linus Torvalds wrote:
> > @@ -161,14 +161,15 @@ static int options_show(struct seq_file *s, void *p)
> >  static ssize_t options_write(struct file *file, const char __user *userbuf,
> >  			     size_t count, loff_t *data)
> >  {
> > -	unsigned long val;
> > -	char buf[80];
> > +	char buf[16];
> >  
> > -	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
> > +	if (count >= sizeof(buf))
> > +		return -EINVAL;
> > +	if (copy_from_user(buf, userbuf, count))
> >  		return -EFAULT;
> > -	buf[count - 1] = '\0';
> > -	if (!strict_strtoul(buf, 10, &val))
> > -		gru_options = val;
> > +	buf[count] = '\0';
> > +	if (strict_strtoul(buf, 0, &gru_options))
> > +		return -EINVAL;
> >  
> >  	return count;
> >  }
> > 
> > 
> 
> Looks OK to me. I can't test it however, as I don't own the hardware.

"buf" should be larger than 16. The string could be "0x" + 16 characters.

I'll verify the the rest.


We have the hardware :-)


--- jack
