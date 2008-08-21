Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYHUMnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYHUMnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYHUMnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:43:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYHUMnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:43:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.1.10.0808210833080.8202@tundra.namei.org>
References: <alpine.LRH.1.10.0808210833080.8202@tundra.namei.org> <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Further fix execve error handling
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Thu, 21 Aug 2008 13:43:23 +0100
Message-ID: <4783.1219322603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> How about moving the mutex_unlock() out of free_bprm() and into the 
> calling code ?

Okay, I've sent you a patch to do this.  Note that it only affects the error
handling case.  In the case of a successful execution, install_exec_creds()
will release the mutex when it is safe to do so.  This then permits
PTRACE_ATTACH to take place from that point.  I could shift the unlock so that
it always happens in [compat_]do_execve() - do you think it's worth it?  It
would mean that ptrace wouldn't be able to attach to a process that's still
under construction by the binfmt, which is probably reasonable.

David
