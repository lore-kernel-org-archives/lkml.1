Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbXDXEyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbXDXEyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161552AbXDXEyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:54:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51175 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXDXEyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:54:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linas Vepstas <linas@austin.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "<Andrew Morton" <akpm@osdl.org>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695763104-git-send-email-ebiederm@xmission.com>
	<20070422123155.GF20763@infradead.org>
	<20070423205020.GR31947@austin.ibm.com>
	<1177378733.14873.52.camel@localhost.localdomain>
	<m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
	<1177382544.14873.57.camel@localhost.localdomain>
	<m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
	<17965.35054.835790.275270@cargo.ozlabs.ibm.com>
Date: Mon, 23 Apr 2007 22:51:50 -0600
In-Reply-To: <17965.35054.835790.275270@cargo.ozlabs.ibm.com> (Paul
	Mackerras's message of "Tue, 24 Apr 2007 14:34:54 +1000")
Message-ID: <m1647mv0gp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:

> Eric W. Biederman writes:
>
>> Well the basic problem is that for any piece of code that can be modular
>> we need a way to ensure all threads it has running are shutdown when we
>> remove the module.
>
> The EEH code can't be modular, and wouldn't make any sense to be
> modular, since it's part of the infrastructure for accessing PCI
> devices.

Agreed.  However most kthread users are modular and make sense to
be so we need to design to handle modular users.

I don't think the idiom of go fire off a thread to handle something
is specific to non-modular users.

Eric
