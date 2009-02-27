Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZB0AkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZB0AkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZB0Ajz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:39:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46968 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZB0Ajz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:39:55 -0500
Date: Fri, 27 Feb 2009 09:38:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, lizf@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
  file
Message-Id: <20090227093835.8c7e6f23.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830902261628k4ce8e1aflb7981672562801fb@mail.gmail.com>
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
	<20090226130005.3282cb02.akpm@linux-foundation.org>
	<6599ad830902261628k4ce8e1aflb7981672562801fb@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 16:28:11 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Feb 26, 2009 at 1:00 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 25 Feb 2009 16:35:55 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> >>  When I wrote tools for maintain cgroup, I can't find which file is
> >>  writable intarfece or not via cgroup file systems. (finally, I did
> >>  dirty approach.)
> >>  IMHO, showing "this file is read-only" in explicit way is useful
> >>  for user-land (tools). In other story, a file whose name sounds read-only
> >>  may have "trigger" operation and support reseting. In this case,
> >>  "writable" is informative.
> >
> > Well, we have compatibility issues here.  If we make this change, and
> > people write tools which depend upon that change then those tools might
> > break when run upon older kernels.
> 
> I don't think that's too big a deal - a write can always fail at the
> whim of a cgroups subsystem, so this would just be a hint to a tool
> that it shouldn't even bother trying to write to the file. It should
> be able to handle a failure.
> 
> But I don't see why we can't figure out the mode automatically based
> on whether or not there's a write handler defined for the control
> file.
> 
That's because I wanted to allow -w------- or -w--w---- or some

Thanks,
-Kame



> Paul
> 

