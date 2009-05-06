Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZEFXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZEFXu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZEFXur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:50:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:57046 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZEFXur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:50:47 -0400
Date: Thu, 7 May 2009 09:48:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
In-Reply-To: <20090506232703.GA3036@sequoia.sous-sol.org>
Message-ID: <alpine.LRH.2.00.0905070946480.22586@tundra.namei.org>
References: <20090505224729.GA965@redhat.com> <20090506224650.GZ3036@sequoia.sous-sol.org> <20090506231332.GA3756@redhat.com> <20090506232703.GA3036@sequoia.sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Chris Wright wrote:

> * Oleg Nesterov (oleg@redhat.com) wrote:
> > But this can happen without this change too?
> > 
> > - cpu2 takes task_lock(), tracehook_tracer_task() returns NULL because
> >   we are not traced yet.
> > 
> > - cpu1 does ptrace_attach() and succeds, because cpu2 didn't update sid
> >   yet
> > 
> > - cpu2 continues, it doesn't check avc_has_perm() (tracer == 0) and
> >   updates sid.
> > 
> > No?
> 
> Yes.
> 
> > Shouldn't selinux_setprocattr() take ->cred_exec_mutex, like we do in
> > selinux_bprm_set_creds() path?
> 
> I was looking at the same, seems like it to me.  James?

As far as I can tell, yes.

(Added David Howells and security folk to the cc -- please make sure at 
least that the LSM list is cc'd when changing code which affects LSM 
modules).


- James
-- 
James Morris
<jmorris@namei.org>
