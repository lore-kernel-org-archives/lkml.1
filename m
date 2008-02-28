Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbYB1IJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbYB1IJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYB1IJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:09:22 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37390 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYB1IJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:09:21 -0500
X-Sasl-enc: uaqiLxM8gDCqgdSnE4LjrMjTLZkpvrUfx9M0FgOwQc79 1204186160
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080227235952.70a31d9f.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	 <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	 <20080227204546.72e16e8d.akpm@linux-foundation.org>
	 <1204179747.3501.21.camel@raven.themaw.net>
	 <20080227223734.caab0165.akpm@linux-foundation.org>
	 <1204182500.3501.49.camel@raven.themaw.net> <47C667EC.6060700@openvz.org>
	 <20080227235952.70a31d9f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:06:11 +0900
Message-Id: <1204185971.3501.87.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 23:59 -0800, Andrew Morton wrote:
> On Thu, 28 Feb 2008 10:51:08 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
> > > So, why do we need the uid and gid? When someone walks over an autofs
> > > dentry that is meant to cause a mount we send a request packet to the
> > > daemon via a pipe which includes the process uid and gid, and as part of
> > > the lookup we set macros for several mount map substitution variables,
> > > derived from the uid and gid of the process requesting the mount and
> > > they can be used within autofs maps.
> > 
> > Why do we need the uid then? Is just pid not enough to uniquely 
> > identify a task?
> 
> The problem is that the userspace daemon is restarted.  ie: it exits
> and is re-run.  It then needs to pick up various state from its previous
> run.

Dumb old me, I really only need the uid.
The gid can come from the get user info functions of glibc.
DOH!

