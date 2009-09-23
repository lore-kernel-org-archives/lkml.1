Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZIWPp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZIWPp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZIWPp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:45:28 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:54589 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZIWPp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:45:27 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: fanotify as syscalls
Date: Wed, 23 Sep 2009 16:45:28 +0100
User-Agent: KMail/1.9.10
Cc: Andreas Gruenbacher <agruen@suse.de>, Jamie Lokier <jamie@shareable.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
References: <20090912094110.GB24709@ioremap.net> <200909230939.34003.tvrtko.ursulin@sophos.com> <alpine.DEB.2.00.0909230755160.21515@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0909230755160.21515@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Message-Id: <200909231645.29559.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/09/2009 16:45:29,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/09/2009 16:45:30,
	Serialize complete at 23/09/2009 16:45:30
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 September 2009 16:26:49 Davide Libenzi wrote:
> On Wed, 23 Sep 2009, Tvrtko Ursulin wrote:
> > Lived with it because there was no other option. We used LSM while it was
> > available for modules but then it was taken away.
> >
> > And not all vendors even use syscall interception, not even across
> > platforms, of which you sound so sure about. You can't even scan
> > something which is not in your namespace if you are at the syscall level.
> > And you can't catch things like kernel nfsd. No, syscall interception is
> > not really appropriate at all.
>
> Really?
> And *if* namespaces were the problem for the devices you were targeting,
> what prevented you to resolving the object and offering a stream to
> userspace?

You are right, nothing really, we even do it like that today. But what about 
other interested users?

> In *your* module, hosting at the same time all the other logic required
> for it (caches, whitelists, etc...), instead of pushing this stuff into
> the kernel.
> WRT to the "other" system, never said they were using syscall
> interception, if you read carefully. I said that minifilters typically
> sends path names to userspace, which might drive you in the pitfall
> Andreas was describing.

Yeah, you could do something like kauth on OSX, which is I guess similar to 
LSM, which was turned off for out of tree. And now you want to push users of 
fanotify out of tree, so what should it be? In tree bad, out of tree bad? 

Tvrtko
