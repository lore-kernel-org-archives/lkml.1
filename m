Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbZFPXBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbZFPXBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZFPXA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:00:56 -0400
Received: from tundra.namei.org ([65.99.196.166]:56289 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZFPXAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:00:55 -0400
Date: Wed, 17 Jun 2009 09:00:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eugene Teo <eugene@redhat.com>,
       Roland McGrath <roland@redhat.com>, solar@openwall.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] send_sigio_to_task: sanitize the usage of fown->signum
In-Reply-To: <20090616222710.GA7620@redhat.com>
Message-ID: <alpine.LRH.2.00.0906170859530.3185@tundra.namei.org>
References: <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain> <20090616204941.GB28663@redhat.com>
 <alpine.LFD.2.01.0906161433270.16802@localhost.localdomain> <20090616215103.GA4853@redhat.com> <20090616222710.GA7620@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Oleg Nesterov wrote:

> send_sigio_to_task() reads fown->signum several times, we can race with
> F_SETSIG which changes ->signum lockless. In theory, this can fool security
> checks or we can call group_send_sig_info() with the wrong ->si_signo which
> does not match "int sig".
> 
> Change the code to cache ->signum.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
