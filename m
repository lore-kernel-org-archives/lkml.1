Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZIWIsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZIWIsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZIWIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:48:44 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:36358 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZIWIsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:48:42 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 04:48:41 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: fanotify as syscalls
Date: Wed, 23 Sep 2009 09:39:33 +0100
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
References: <20090912094110.GB24709@ioremap.net> <200909221731.34717.agruen@suse.de> <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Message-Id: <200909230939.34003.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/09/2009 09:39:34,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/09/2009 09:39:34,
	Serialize complete at 23/09/2009 09:39:34
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009 17:04:44 Davide Libenzi wrote:
> On Tue, 22 Sep 2009, Andreas Gruenbacher wrote:
> > The fatal flaw of syscall interception is race conditions: you look up a
> > pathname in your interception layer; then when you call into the proper
> > syscall, the kernel again looks up the same pathname. There is no way to
> > guarantee that you end up at the same object in both lookups. The
> > security and fsnotify hooks are placed in the appropriate spots to avoid
> > exactly that.
>
> Fatal? You mean, for this corner case that the anti-malware industry lived
> with for so much time (in Linux and Windows), you're prepared in pushing
> all the logic that is currently implemented into their modules, into the
> kernel?

Lived with it because there was no other option. We used LSM while it was 
available for modules but then it was taken away. 

And not all vendors even use syscall interception, not even across platforms, 
of which you sound so sure about. You can't even scan something which is not 
in your namespace if you are at the syscall level. And you can't catch things 
like kernel nfsd. No, syscall interception is not really appropriate at all.

Tvrtko
