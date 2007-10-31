Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbXJaUUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbXJaUUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXJaUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:19:56 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:58515 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbXJaUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:19:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HABOAKEdMQWvU/2dsb2JhbACBWo5b
Date: Wed, 31 Oct 2007 16:19:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: fix marker warnings
Message-ID: <20071031201952.GA17235@Krystal>
References: <1193774725.24087.303.camel@localhost> <20071031020830.GA1176@Krystal> <1193859495.6271.21.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1193859495.6271.21.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:18:50 up 93 days, 20:37,  4 users,  load average: 0.42, 0.55, 0.54
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> On Tue, 2007-10-30 at 22:08 -0400, Mathieu Desnoyers wrote:
> > * Dave Hansen (haveblue@us.ibm.com) wrote:
> > > I'm seeing these in the latest git:
> > > 
> > > kernel/marker.c: In function `marker_probe_unregister':
> > > kernel/marker.c:355: warning: `probe_module' might be used uninitialized in this function
> > > kernel/marker.c: In function `marker_probe_unregister_private_data':
> > > kernel/marker.c:389: warning: `probe_module' might be used uninitialized in this function
> > > kernel/marker.c:392: warning: `entry' might be used uninitialized in this function
> > > 
> > > It's due to gcc not detecting that the need_update condition is actually
> > > constant, and will never call marker_update_probes() on an uninitialized
> > > probe_module.
> > > 
> > > However, that need_update bit is all due to dropping the mutex before
> > > calling marker_update_probes().  As far as I can tell, every call to
> > > marker_update_probes() has this lock dropping behavior just before
> > > calling it.  So, let's just hold the locks over the
> > > marker_update_probes() and document that it needs to have a lock taken
> > > instead.  
> > > 
> > > This removes code overall.  Untested except for a quick compile.
> > > Consider it just a style suggestion. :)
> > > 
> > 
> > Ok, just ran it and it seems good. It did not appear as trivial during
> > development because locking was is a different order until recently.
> > 
> > I wonder what gcc version you are using though, because mine does not
> > warn about anything. I wonder if it is really necessary to "fix" false
> > gcc warnings like this. Let's take it as a cleanup.
> 
> dave@kernel:~$ gcc -v
> Reading specs from /usr/lib/gcc-lib/x86_64-linux-gnu/3.3.6/specs
> Configured with: ../src/configure -v --enable-languages=c,c++
> --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
> --with-gxx-include-dir=/usr/include/c++/3.3 --enable-shared
> --enable-__cxa_atexit --with-system-zlib --enable-nls
> --without-included-gettext --enable-clocale=gnu --enable-debug
> --disable-multilib x86_64-linux-gnu
> Thread model: posix
> gcc version 3.3.6 (Ubuntu 1:3.3.6-15ubuntu1)
> 
> 
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Do you have any other patches with which you would like to forward this
> one?  Or, shall I send it upstream on its own?
> 

For the marker infrastructure itself, that's the only one. I think
sending it to Andrew Morton is the correct approach.

Mathieu

> -- Dave
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
