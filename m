Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXCVOjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXCVOjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXCVOjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:39:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45360 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbXCVOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:39:12 -0400
Date: Thu, 22 Mar 2007 09:39:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, pj@sgi.com, Sam Vilain <sam@vilain.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org, dev@sw.ru
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070322143909.GC6981@sergelap.austin.ibm.com>
References: <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <45EF793C.1000700@vilain.net> <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com> <45EF83CB.9080903@vilain.net> <6599ad830703080110i33405501tb12bf8e58bf829c9@mail.gmail.com> <20070309165017.GF5948@sergelap.austin.ibm.com> <20070322140814.GA20796@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322140814.GA20796@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Fri, Mar 09, 2007 at 10:50:17AM -0600, Serge E. Hallyn wrote:
> > The nsproxy container subsystem could be said to be that unification.
> > If we really wanted to I suppose we could now always mount the nsproxy
> > subsystem, get rid of tsk->nsproxy, and always get thta through it's
> > nsproxy subsystem container.  But then that causes trouble with being
> > able to mount a hierarachy like
> > 
> > 	mount -t container -o ns,cpuset
> 
> What troubles will mounting both cpuset and ns in the same hierarchy
> cause?

Wow, don't recall the full context here.  But at least with Paul's
container patchset, a subsystem can only be mounted once.  So if the
nsproxy container subsystem is always mounted by itself, then you cannot
remount it to bind it with cpusets.

> IMO that may be a good feature by itself, which makes it convenient to 
> bind different containers to different cpusets.

Absolutely.

-serge

> In this case, we want 'ns' subsystem to override all decisions wrt
> mkdir of directories and also movement of tasks b/n different
> groups. This is automatically accomplished in the patches, by having ns
> subsystem veto mkdir/can_attach request which aren't allowed as per
> namespace semantics (but which may be allowed as per cpuset semantics).
> 
> > so we'd have to fix something.  It also slows things down...
> 
> -- 
> Regards,
> vatsa
