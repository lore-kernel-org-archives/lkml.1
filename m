Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZFPXLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZFPXLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbZFPXLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:11:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763333AbZFPXLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:11:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090616222710.GA7620@redhat.com>
References: <20090616222710.GA7620@redhat.com> <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain> <20090616204941.GB28663@redhat.com> <alpine.LFD.2.01.0906161433270.16802@localhost.localdomain> <20090616215103.GA4853@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Eugene Teo <eugene@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, solar@openwall.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] send_sigio_to_task: sanitize the usage of fown->signum
Date: Wed, 17 Jun 2009 00:10:24 +0100
Message-ID: <10534.1245193824@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> send_sigio_to_task() reads fown->signum several times, we can race with
> F_SETSIG which changes ->signum lockless. In theory, this can fool security
> checks or we can call group_send_sig_info() with the wrong ->si_signo which
> does not match "int sig".
> 
> Change the code to cache ->signum.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
