Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXKEJl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXKEJl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 04:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXKEJlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 04:41:50 -0500
Received: from hu-out-0506.google.com ([72.14.214.236]:17022 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbXKEJls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 04:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=RoT7OsSCG0q7/GRdKsCtI1PklP4XgwPWPt6bORgAqggGi4VgQ5AlLdEXqCsfYY0IGdz8wtkQWWZWvOL6rRgn9CVWR48PwhrYW4X/IYnWKDV0dz20k/WNHOz+OKD0IViMfJPFGqGVSzvjbkLd4l/mraC+Tz41wreSrArNQOhfMO4=
Date: Mon, 5 Nov 2007 11:41:25 +0200
To: Pavel Machek <pavel@ucw.cz>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071105094007.GA19367@ubuntu>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104122848.GC3921@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 12:28:48PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > Still to come:
> > > 
> > >   - Final cleanup of smack_load_write and smack_cipso_write.
> > 
> > Hi All,
> > 
> > After agreeing with Casey on the "load" input grammar yesterday, here's
> > the final grammar and its parser (which needs more testing):
> > 
> > A Smack Rule in an "egrep" format is:
> > 
> > "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
> > 
> > where Subject/Object strings are in the form:
> > 
> > "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
> 
> Can we avoid string parsers in the kernel?
> 

Ok, Could someone suggest a better idea please ?. 

I thought about packing the rules in a structure and sending
it over an ioctl() command. Is this applicable ?

> 
> > +static inline int isblank(char c)
> > +{
> > +	return (c == ' ' || c == '\t');
> > +}
> 
> This sounds like enough for 'NAK'.
> 
> 						Pavel,
> 		who still thinks smack rules should be parsed
> 		in userspace and compiled into selinux rules...
> 		
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
