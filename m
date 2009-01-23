Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbZAWJKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbZAWJKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZAWJKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:10:05 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54367 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbZAWJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:10:01 -0500
X-Sasl-enc: 8W3FHgWNIhSi/5DoWyu/h54GP3pkkMv67prjp1NSeViO 1232701799
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20090123081312.GB4002@redhat.com>
References: <20090118073441.GA699@redhat.com>
	 <1232686100.3011.18.camel@zeus.themaw.net>
	 <20090123081312.GB4002@redhat.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 18:09:55 +0900
Message-Id: <1232701795.3011.39.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 09:13 +0100, Oleg Nesterov wrote:
> On 01/23, Ian Kent wrote:
> >
> > But I think that for debug logging we should always report numbers that
> > correspond to the object as it is seen in the global namespace as that
> > is the most likely reference point someone examining debug logging will
> > be working from.
> >
> > Oleg, what should be the recommended call to report that, instead of the
> > task_pgrp_nr() call?
> 
> task_pgrp_nr_ns(tsk, &init_pid_ns) gives the same result. Except, if the
> tsk has already exited it returns 0.
> 
> 
> But, Ian, if you prefer to use task_pgrp_nr() - just use it. Personally,
> I'd like to kill task_pgrp_nr(), but I can't "prove" it should die.

I'm not concerned with what's used so much as fitting in with the pid
namespace effort and maintaining sensible debug output. This stuff has
been in autofs4 since long before the pid namespace work began and the
changes to it weren't done by me anyway.

Ian


