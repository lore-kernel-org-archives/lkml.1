Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZBKRIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZBKRIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZBKRIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:08:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37657 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbZBKRIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:08:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090211163331.GA4251@elte.hu>
References: <20090211163331.GA4251@elte.hu> <20090211214639.C3D0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27780.1234356078@redhat.com> <31230.1234357767@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Wed, 11 Feb 2009 17:07:48 +0000
Message-ID: <1576.1234372068@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> include/linux/cred.h: In function 'get_cred':
> include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards 
> qualifiers from pointer target type

This is a known compiler bug in some versions of gcc.  It fails to observe the
fact that a const pointer is cast to the equivalent non-const pointer in
get_cred():

	static inline const struct cred *get_cred(const struct cred *cred)
	{
		return get_new_cred((struct cred *) cred);
	}

David
