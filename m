Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYB1IAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYB1IAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYB1IAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:00:18 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbYB1IAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:00:17 -0500
Date: Wed, 27 Feb 2008 23:59:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ian Kent <raven@themaw.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
Message-Id: <20080227235952.70a31d9f.akpm@linux-foundation.org>
In-Reply-To: <47C667EC.6060700@openvz.org>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	<20080227204546.72e16e8d.akpm@linux-foundation.org>
	<1204179747.3501.21.camel@raven.themaw.net>
	<20080227223734.caab0165.akpm@linux-foundation.org>
	<1204182500.3501.49.camel@raven.themaw.net>
	<47C667EC.6060700@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 10:51:08 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> > So, why do we need the uid and gid? When someone walks over an autofs
> > dentry that is meant to cause a mount we send a request packet to the
> > daemon via a pipe which includes the process uid and gid, and as part of
> > the lookup we set macros for several mount map substitution variables,
> > derived from the uid and gid of the process requesting the mount and
> > they can be used within autofs maps.
> 
> Why do we need the uid then? Is just pid not enough to uniquely 
> identify a task?

The problem is that the userspace daemon is restarted.  ie: it exits
and is re-run.  It then needs to pick up various state from its previous
run.
