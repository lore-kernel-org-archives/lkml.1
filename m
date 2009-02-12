Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZBLRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZBLRSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZBLRSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:18:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbZBLRSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:18:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090212143932.GA10101@us.ibm.com>
References: <20090212143932.GA10101@us.ibm.com> <20090212202118.0A58.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27421.1234436992@redhat.com> <27547.1234440246@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Thu, 12 Feb 2009 17:18:24 +0000
Message-ID: <12311.1234459104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> 	1. put_user_ns() was being called before the uid (which
> 	   was in the init_user_ns) was unhashed

Ah yes...  but only if CONFIG_USER_NS=y.  Otherwise the unhash was being done
before the release anyway.  With this option set, the unhash was being deferred
to a workqueue thread.

Okay, that seems reasonable.

David
