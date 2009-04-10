Return-Path: <linux-kernel-owner+w=401wt.eu-S937893AbZDJMWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937893AbZDJMWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935698AbZDJMTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:19:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935607AbZDJMTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:19:36 -0400
Date: Fri, 10 Apr 2009 14:15:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible
	ptrace issue?)
Message-ID: <20090410121525.GA4760@redhat.com>
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org> <20090409194912.GA30645@us.ibm.com> <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org> <20090409213910.GB30645@us.ibm.com> <B6C30A35-DBF7-4710-9F03-9E42775CDA21@kernel.crashing.org> <20090410010319.GA2354@us.ibm.com> <910A25D6-E6E6-4742-B9F4-52532D92117D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910A25D6-E6E6-4742-B9F4-52532D92117D@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Kumar Gala wrote:
>
> That seems to clear it up.. But why has the behavior changed?  I didn't
> have to do the "kill -CONT 1" on 2.6.29.

I didn't look at the test-case yet, so I don't know what happens.

But, before this comment, /sbin/init always ignored SIGSTOP.
Now it is possible to stop init. Of course, user-space can't
send SIGSTOP to init directly. But if you are ptracer, or send
SIGSTOP to the sub-namespace, it should work.

Oleg.

