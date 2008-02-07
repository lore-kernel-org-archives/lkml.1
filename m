Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbYBGUu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbYBGUu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYBGUuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42807 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbYBGUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:23 -0500
Date: Thu, 7 Feb 2008 14:50:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][DOCUMENTATION] Minimal controller code for a quick
	start
Message-ID: <20080207205021.GB16628@sergelap.ibm.com>
References: <47AB25AD.30400@openvz.org> <1202416137.6274.42.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202416137.6274.42.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Zijlstra (a.p.zijlstra@chello.nl):
> 
> On Thu, 2008-02-07 at 18:37 +0300, Pavel Emelyanov wrote:
> > The Documentation/cgroups.txt file contains the info on how
> > to write some controller for cgroups subsystem, but even with
> > this, one need to write quite a lot of code before developing
> > the core (or copy-n-paste it from some other place).
> > 
> > I propose to put this minimal controller into Documentation
> > directory to let people copy-n-paste a) from a known place and 
> > b) a small piece of code.
> > 
> > Besides, many people learn better reading an example rather
> > than/along with a document.
> 
> 
> While on the subject, could someone document struct cgroup_subsys. In
> particular, I've wondered why we have: cgroup_subsys::can_attach() and

The point of can_attach() is to decide whether an attach should be
permitted.  kernel/ns_cgroup.c defines it.

> not use a return value in cgroup_subsys::attach()?

IIUC, by the point ->attach() is called, the task has already been placed
in the new cgroup, and we're just asking each subsystem to update any
relevant accounting.

-serge
