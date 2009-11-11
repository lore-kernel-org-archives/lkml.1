Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZKKATd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZKKATd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZKKATc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:19:32 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34583 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZKKATb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:19:31 -0500
Date: Tue, 10 Nov 2009 18:19:14 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Message-ID: <20091111001914.GA30470@us.ibm.com>
References: <20091110140739.GA15534@us.ibm.com>
 <200911101028.10797.sgrubb@redhat.com>
 <20091110155349.GA18185@us.ibm.com>
 <200911101251.21703.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911101251.21703.sgrubb@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Steve Grubb (sgrubb@redhat.com):
> On Tuesday 10 November 2009 10:53:49 am Serge E. Hallyn wrote:
> > > > Does anyone know of cases where CONFIG_SECURITY_FILE_CAPABILITIES=n
> > > > is still perceived as useful?
> > >
> > > 
> > > As a library writer, I wished that the kernel behavior was either
> > > consistent,  or there is an API that I can use to find out what model we
> > > are operating under. The biggest issue is that for a distribution we know
> > > the assumptions the distribution should be running under. But end users
> > > are free to build their own kernel that has it disabled. This has already
> > > lead to dbus not working at all.
> > > 
> > > I also take issue with probing the capability version number returning
> > > EINVAL  when its the only way to find out what the preferred version is.
> > 
> > In 2007/2008, KaiGai had floated patches to export capability info
> > over securityfs.  If it was something library writers and distros
> > wanted, we could resurrect those patches - and tack on some info
> > about cap-related kernel config.
> 
> Unfortunately, I would have to support the kernels from 2.6.26->2.6.32 which 
> presumably don't have this facility. So, I'm kind of stuck. I think in a 
> previous discussion you mentioned that I could call getcap or 
> prctl(PR_CAPBSET_READ) and check for CAP_SETPCAP. I think I have to go that 
> direction for backwards compatibility.

Yes, I'm afraid so - unless /proc/config.gz happened to be available.
I suppose looking through /proc/1/status might be more reliable
actually, in case you were running in an already-partially-restricted
process tree.

> But back to detecting the capability version number...if I pass 0 as the 
> version in the header, why can't the kernel just say oh you want the preferred 
> version number, stuff it in the header, and return the syscall with success and 
> not EINVAL?

This is something I believe Andrew has advocated in the past, but I
forget why.  Andrew?

> Another irritation...if I want to clear the bounding set, I have to make a for 
> loop and call prctl 34 times (once for each bit). I'd rather see a v4 
> capability that takes the bounding set as part of the same syscall. Maybe all 
> 3 of these could be fixed in the same OS release so that changing to v4 also 
> signifies the other behavior changes.

I worry a bit about people confusing the bounding set as something
more  flexible than it is, and/or getting lazy and using the bounding
set instead of fI|pI .vs. fP, but am not solidly against this.

Anyway, maybe we should get on thsi sooner rather than later...
Are there any other deficiencies people see  in the current
API?

-serge
