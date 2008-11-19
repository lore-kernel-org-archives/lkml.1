Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYKSSzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYKSSzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYKSSyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:54:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYKSSyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:54:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] simplify sig_ignored() pathes
In-Reply-To: Oleg Nesterov's message of  Tuesday, 18 November 2008 18:59:05 +0100 <20081118175905.GA17142@redhat.com>
References: <20081118175905.GA17142@redhat.com>
X-Windows: ignorance is our most important resource.
Message-Id: <20081119185329.1FEC01544EB@magilla.localdomain>
Date: Wed, 19 Nov 2008 10:53:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code which checks for ignored signals is a bit overcomplicated
> because tracehook_consider_ignored_signal() wants the "handler" arg.
> Can't we kill it? It is not used even with utrace, and even if it will
> be used later it is OK to read ->sighand again in the slow path.

Yeah, it's fine to kill the arg.  For consistency, change
tracehook_consider_fatal_signal to match.  They are specified as called
with the siglock held, so it will indeed be easy and safe to check
->sighand if tracing code wants to distinguish the cases in the future.


Thanks,
Roland
