Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZASHpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZASHpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 02:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZASHpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 02:45:04 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35982 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbZASHpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 02:45:03 -0500
X-Sasl-enc: JCQg8LkXHlskCYivIeo5ph7u3t4oIPBZD9Vpzp2z72N7 1232351101
Subject: Re: [PATCH] autofs: fix the wrong usage of the
	deprecated	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
In-Reply-To: <49741F14.80808@zytor.com>
References: <20090118073441.GA699@redhat.com>
	 <1232331602.3136.19.camel@zeus.themaw.net>  <49741F14.80808@zytor.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 16:45:01 +0900
Message-Id: <1232351101.3136.87.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 22:35 -0800, H. Peter Anvin wrote:
> Ian Kent wrote:
> > On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
> >> parse_options(&pgid) sets pgid = task_pgrp_nr() which uses the global
> >> namespace. This is wrong, we use this pgid to find "struct pid" in the
> >> current's namespace. Change parse_options() to use task_pgrp_vnr().
> >>
> >> Also do s/task_pgrp_nr/task_pgrp_vnr/ in the debugging printks.
> >> checkpatch.pl complains about "line over 80 characters", but it should
> >> blame the cuurent code, not the patch.
> > 
> > This changelog entry doesn't really have anything that I can use to work
> > out if this change might introduce regressions.
> > 
> > It would be helpful to me if you could include:
> > 1) A brief statement about what your trying to achieve and why.
> > 2) The reason why task_pgrp_nr() has changed to task_pgrp_vnr() since
> > you made the change (that is someone working on pid namespaces) to
> > task_pgrp_nr().
> > 3) Why you believe this change won't introduce a regression.
> > 
> 
> The other thing is also: isn't it high time to remove autofs 3?  It has
> been unmaintained for at least 10 years now.  I should know ;)

That's a good idea.
Couldn't we rename autofs4 to autofs and add a MODULE_ALIAS("autofs4")
or something?

Ian


