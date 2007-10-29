Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbXJ2ND3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbXJ2ND3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXJ2NDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:03:17 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:44147 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbXJ2NDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=q5BvWF348SOJVXKs71Z9hjJZQuRvw7IdgWQogkgrfSromQ2BsYqlsQEFARRf+i4DyH/OfNIGQkpax+SnDxUnEN9CLFOWU39fQL+mVV7knDqw+XGdDFbe7HYdgrPvJAl7fIDtJV5du9LGuerjFVnlFztjgTybTMPKHhNHMhKtxSo=
Date: Mon, 29 Oct 2007 11:03:04 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org, torvalds@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] proc_fs.h redux
Message-ID: <20071029130304.GA7810@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
	torvalds@osdl.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20071027194758.GD9816@martell.zuzino.mipt.ru> <1193524804.26695.103.camel@localhost> <20071028084441.GA24221@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028084441.GA24221@uranus.ravnborg.org>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Oct 28, 2007 at 09:44:41AM +0100, Sam Ravnborg escreveu:
> > 
> > As a general rule, I think it better to use includes
> > than use naked forward declarations.
> 
> Quite the opposite - at least in the kernel source.
> The general rule is that a .h file shall include the
> .h files which contain declarations used by said .h files.
> But naked declarations as above is preferred over including
> a full header file.

yup
 
> We see the full header dependency thing to blow off when
> inline function are used - which is more and more the case.
> In several cases we have converted inline functions to macros
> just to simplify the nightmare of header dependencies we have.
> 
> Arnaldo have a nice script that generate a .ps file
> showing all the dependencies.
> He lately posted this URL: http://oops.ghostprotocols.net:81/acme/tcp.h.ps

Well, not "lately", it has been quite a while. But lets celebrate the
fact that there is somebody trying to fight this battle one more time
and update this tcp.h dependency tree... /me looks for hviz... and if
graphviz is installed, ok:

http://www.kernel.org/pub/linux/kernel/people/acme/hviz

hviz include/linux/tcp.h 10 | dot -Tpdf > /tmp/tcp.h.2007_11.pdf

http://oops.ghostprotocols.net:81/acme/tcp.h.2007_11.pdf

We still get to sched.h, but before it was:

linux/tcp.h -> linux/skbuff.h -> linux/mm.h -> linux/sched.h

Nowadays its:

linux/tcp.h -> linux/sock.h -> linux/netdevice.h -> linux/interrupt.h -> linux/sched.h

And I just removed "#include <linux/sched.h> from linux/interrupt.h,
because as far as I checked it is completely unnecessary, and the
kernel builds just fine :-)

- Arnaldo
