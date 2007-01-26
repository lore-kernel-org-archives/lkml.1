Return-Path: <linux-kernel-owner+w=401wt.eu-S1030244AbXAZKZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030244AbXAZKZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030846AbXAZKZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:25:04 -0500
Received: from mail.screens.ru ([213.234.233.54]:45308 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030845AbXAZKZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:25:03 -0500
Date: Fri, 26 Jan 2007 13:23:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Daniel Hokka Zakrisson <daniel@hozac.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, herbert@13thfloor.at, akpm@osdl.org,
       trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix exit race by splitting exit
Message-ID: <20070126102315.GA110@tv-sign.ru>
References: <20070126052659.GA23250@sergelap.austin.ibm.com> <41241.192.168.101.6.1169806186.squirrel@intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41241.192.168.101.6.1169806186.squirrel@intranet>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Daniel Hokka Zakrisson wrote:
>
> Serge E. Hallyn wrote:
> > Ok, could you verify that the following patch at least solves
> > the oopsing?
> >
> > (I can't reproduce the oops with Daniel's test prog)
> >
> > thanks,
> > -serge
> 
> Indeed, this patch solves the oopsing, but so did the last one. I think I
> finally managed to figure out why too, as release_task would be called
> with current referring to the parent process, or whoever is reaping the
> process with the last reference to the namespace. Right?

Not always. The task can do release_task() on itself if it is sub-thread,
or its parent ignores SIGCHLD.

Anyway I think your explanation is correct for this particular test-case.

Oleg.

