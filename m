Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXCHLXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXCHLXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXCHLXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:23:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54699 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXCHLXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:23:44 -0500
Date: Thu, 8 Mar 2007 17:00:54 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Sam Vilain <sam@vilain.net>
Cc: Paul Menage <menage@google.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070308113054.GB29051@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <45EF5DB9.50606@vilain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EF5DB9.50606@vilain.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 01:50:01PM +1300, Sam Vilain wrote:
> 7. resource namespaces

It should be. Imagine giving 20% bandwidth to a user X. X wants to
divide this bandwidth further between multi-media (10%), kernel
compilation (5%) and rest (5%). So,

> Is the subservient namespace's resource usage counting against ours too?

Yes, the resource usage of children should be accounted when capping
parent resource usage.

> Can we dynamically alter the subservient namespace's resource allocations?

Should be possible yes. That lets user X completely manage his
allocation among whatever sub-groups he creates.

> So let's bring this back to your patches. If they are providing
> visibility of ns_proxy, then it should be called namesfs or some such.

The patches should give visibility to both nsproxy objects (by showing
what tasks share the same nsproxy objects and letting tasks move across
nsproxy objects if allowed) and the resource control objects pointed to
by nsproxy (struct cpuset, struct cpu_limit, struct rss_limit etc).

> It doesn't really matter if processes disappear from namespace
> aggregates, because that's what's really happening anyway. The only
> problem is that if you try to freeze a namespace that has visibility of
> things at this level, you might not be able to reconstruct the
> filesystem in the same way. This may or may not be considered a problem,
> but open filehandles and directory handles etc surviving a freeze/thaw
> is part of what we're trying to achieve. Then again, perhaps some
> visibility is better than none for the time being.
> 
> If they are restricted entirely to resource control, then don't use the
> nsproxy directly - use the structure or structures which hang off the
> nsproxy (or even task_struct) related to resource control.

-- 
Regards,
vatsa
