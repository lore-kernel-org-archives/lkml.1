Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZDXQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZDXQr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760621AbZDXQoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:44:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52214 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760657AbZDXQog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:44:36 -0400
Date: Fri, 24 Apr 2009 18:39:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: ptrace && cred_exec_mutex (Was: [PATCH] ptrace:
	tracehook_unsafe_exec: remove the stale comment)
Message-ID: <20090424163949.GA12035@redhat.com>
References: <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423232717.975ABFC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(change subject, add more CCs)

On 04/23, Roland McGrath wrote:
>
> > tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.
>
> Please make it instead say that cred_exec_mutex is held by the caller
> through the exec.

Yes. Except it looks like ->cred_exec_mutex is never used in fact.

ptrace_attach() takes current->cred_exec_mutex ? iow, ptrace and exec
use different locks ?

Oleg.

