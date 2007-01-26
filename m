Return-Path: <linux-kernel-owner+w=401wt.eu-S1030792AbXAZGbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030792AbXAZGbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030795AbXAZGbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:31:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48130 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030792AbXAZGbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:31:35 -0500
Date: Thu, 25 Jan 2007 22:30:56 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix exit race by splitting exit
Message-Id: <20070125223056.c77b0e97.akpm@osdl.org>
In-Reply-To: <20070126052659.GA23250@sergelap.austin.ibm.com>
References: <20070126052659.GA23250@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 23:26:59 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Fix exit race by splitting the nsproxy putting into two pieces.
> First piece reduces the nsproxy refcount.  If we dropped the last
> reference, then it puts the mnt_ns, and returns the nsproxy as a
> hint to the caller.  Else it returns NULL.  The second piece of
> exiting task namespaces sets tsk->nsproxy to NULL, and drops the
> references to other namespaces and frees the nsproxy only if an
> nsproxy was passed in.
> 
> A little awkward and should probably be reworked, but hopefully
> it fixes the NFS oops.

I'm a bit worried about jamming something like this into 2.6.20.  Could the
usual culprits please review this carefully with some urgency?

And Daniel, if you can find time to runtime test it please?
