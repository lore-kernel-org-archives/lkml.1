Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXJWHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXJWHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXJWHWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:22:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbXJWHWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:22:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XImSowJJIqajBYTtxxyWh5oSAfpVAG24eCC+D+f9Jt5e/ZRx8kfPnCro3gsvlDbYr
	it5RniO1fXeAzStmwt5MA==
Message-ID: <6599ad830710230021n536908c0xd95250f36aa8a27d@mail.gmail.com>
Date: Tue, 23 Oct 2007 00:21:59 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023024036.GC3324@linux.vnet.ibm.com>
	 <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Paul Menage <menage@google.com> wrote:
>
> Using cgroup_mutex is certainly possible for now, although more
> heavy-weight than I'd like long term. Using css_get isn't the right
> approach, I think - we shouldn't be able to cause an rmdir to fail due
> to a concurrent read.
>

OK, the obvious solution is to use the same approach for subsystem
state objects as we do for the struct cgroup itself - move the calls
to the subsystem destroy methods to cgroup_diput. A control file
dentry will keep alive the parent dir's dentry, which will keep alive
the cgroup and (with this change) the subsystem state objects too.

The only potential drawback that I can see is that an open fd on a
cgroup directory or a control file will keep more memory alive than it
would have done previously.

Paul
