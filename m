Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZD2KDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZD2KDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZD2KDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:03:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZD2KDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:03:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090429065809.GA477@redhat.com>
References: <20090429065809.GA477@redhat.com> <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Date: Wed, 29 Apr 2009 11:02:50 +0100
Message-ID: <7242.1240999370@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> we can flush the signal which was sent after we changed SID/cred and passed
> the new permission checks,

I think you mean to say, rather, that we can *lose* a signal that was sent,
because flush_signals() discards all pending signals unconditionally, and so
SIGKILL can be lost?

I suspect we should pass SIGKILL and possibly SIGSTOP through the flush.

David
