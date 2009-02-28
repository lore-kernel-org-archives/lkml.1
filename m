Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZB1BMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZB1BMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZB1BLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:11:55 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52403 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZB1BLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:11:54 -0500
Date: Sat, 28 Feb 2009 06:41:15 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ken Chen <kenchen@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] change cpuacct usage percpu format v2
Message-ID: <20090228011115.GC28769@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com> <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com> <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com> <b0f5e75d938ffb61bdda7c88b962d3fe.squirrel@webmail-b.css.fujitsu.com> <b040c32a0902271600h31785bb8q93acde59f5d15e3d@mail.gmail.com> <661fca240cb094bcf4d261ccebab9848.squirrel@webmail-b.css.fujitsu.com> <c73ef954d3030022416d249ba8fefe8e.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c73ef954d3030022416d249ba8fefe8e.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 09:42:17AM +0900, KAMEZAWA Hiroyuki wrote:
> KAMEZAWA Hiroyuki wrote：
> > Ken Chen wrote：
> >> On Fri, Feb 27, 2009 at 3:34 PM, KAMEZAWA Hiroyuki
> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >>> "a lot of" ? I talking about cpu hotplug and reading another file as
> >>> /sys/devices/system/cpu/present every time before reading this file
> >>> gives much much much more overhead ;)
> >>
> >> yes, really a lot.  CPU hotplug is an uncommon event.  It happens
> >> perhaps once a day? maybe once an hour?
> >>
> > Are you saying the software should have hotplug script and send SIGHUP or
> > some to reload the present map ?
> >
> >> User monitoring process usually reads usage_percpu at fairly high
> >> rate, say once a sec.  At each pass it will need to parse N number of
> >> CPU index.  The overhead is N_CPU * T, where T is time in second
> >> between cpu hotplug event.  Assume T = one day, on a moderate sized
> >> 64-CPU size machine, the overhead is:
> >>
> >> 64 * 86400 : 1, that's like 5.5 million to 1 ratio.  To me that is
> >> *high* overhead.
> >>
> > Sounds strange. I can't catch hat you want to say.
> >
> Ignore above, I caught, at last. I'll add text to documenation.
> 
> BTW, current interface to reset cpuacct (write ops) just reset
> specified level of cpuacct and will not clear other hierarchical levels.
> Doesn't this behavior confuse software ?
> 

hmmm. This got missed when we introduced hierarchy. But I wonder if it
is needed?

-- 
regards,
Dhaval
