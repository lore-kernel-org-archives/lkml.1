Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZDPJpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZDPJpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZDPJo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:44:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZDPJo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:44:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090413220201.GA1368@redhat.com>
References: <20090413220201.GA1368@redhat.com> <20090413201348.GA16661@redhat.com> <20090413201306.GA16653@redhat.com> <32305.1239659266@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Serge Hallyn <serue@us.ibm.com>,
       Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_execute() needs mb() before test_bit(SLOW_WORK_PENDING)
Date: Thu, 16 Apr 2009 10:43:42 +0100
Message-ID: <14774.1239875022@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> But why do we need the barrier before clear_bit(SLOW_WORK_EXECUTING) ?
> We do have one after test_and_clear_bit(SLOW_WORK_PENDING) above, and it
> should be enough, no?

No.  There lock is covering work->ops->execute(work) too, and that is after
the clearance of SLOW_WORK_PENDING.  The UNLOCK-class barrier must go between
execution and clearance of the execution lock bit.

David
