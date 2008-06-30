Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbYF3NVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbYF3NVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbYF3NVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:21:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762974AbYF3NVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:21:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <48635799.3010500@kernel.org>
References: <48635799.3010500@kernel.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/4] security: filesystem capabilities bugfix1
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 30 Jun 2008 14:15:11 +0100
Message-ID: <29651.1214831711@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew G. Morgan <morgan@kernel.org> wrote:

> +kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)

Hmmm... kernel_cap_t is a structure that might not fit into a single register.
It occurs to me that you might be better off returing the old caps through a
pointer argument.  It should still work, though.

The SElinux and syscalls LTP testscripts work okay for these patches when
ported to linux-next.  The filecaps LTP testscript can't be used on Fedora 9
as the setcap command is used incorrectly.

Acked-by: David Howells <dhowells@redhat.com>

David
