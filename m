Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbYAXVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYAXVEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYAXVEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:04:38 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:52019 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYAXVEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:04:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FANOLmEdMQWYq/2dsb2JhbACBV5AfnT4
Date: Thu, 24 Jan 2008 16:04:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
Message-ID: <20080124210431.GA1647@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <20080124125845.bf5767b8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080124125845.bf5767b8.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:02:41 up 82 days,  2:08,  6 users,  load average: 0.59, 1.53,
	1.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Thu, 24 Jan 2008 15:27:13 -0500 Mathieu Desnoyers wrote:
> 
> > Add initialization of an array, which needs brackets that would pollute kernel
> > code, to kernel.h. It is used to declare arguments passed as function parameters
> 
> Hi Mathieu,
> 
> Maybe you have explained this previously, but please give a short
> explanation of "brackets that would pollute kernel code".
> 
> Thanks.
> 

Try opening such code in vim, and the syntax highlighting gets all
messed up :-/

The other option is to do the *right thing* and fix vim, of course, but
this change won't be in distros for a while.

Mathieu

> > such as:
> > text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > ---
> >  include/linux/kernel.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: linux-2.6-lttng.mm/include/linux/kernel.h
> > ===================================================================
> > --- linux-2.6-lttng.mm.orig/include/linux/kernel.h	2008-01-24 14:10:54.000000000 -0500
> > +++ linux-2.6-lttng.mm/include/linux/kernel.h	2008-01-24 14:23:06.000000000 -0500
> > @@ -423,4 +423,6 @@ struct sysinfo {
> >  #define NUMA_BUILD 0
> >  #endif
> >  
> > +#define INIT_ARRAY(type, val, len) ((type [len]) { [0 ... (len)-1] = (val) })
> > +
> >  #endif
> 
> ---
> ~Randy

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
