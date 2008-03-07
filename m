Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYCGGjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYCGGjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYCGGjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:39:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39299 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752007AbYCGGja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:39:30 -0500
Date: Fri, 7 Mar 2008 00:39:24 -0600
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080307003924.6dcb16a3.pj@sgi.com>
In-Reply-To: <20080306214003.aba81840.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<1204568316.8514.18.camel@twins>
	<20080304013534.4e51ae48.pj@sgi.com>
	<1204628762.6241.46.camel@lappy>
	<47CDA885.3000103@qualcomm.com>
	<20080304191159.a02be58b.pj@sgi.com>
	<1204706272.6241.79.camel@lappy>
	<20080306074729.6233e537.pj@sgi.com>
	<1204816885.6241.265.camel@lappy>
	<20080306214003.aba81840.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pj wrote:
> These 'irqs.N.name' files would be the first instance of allowing
> user created files in cpuset directories.  That will require some
> changes to the cpuset or cgroup code; I don't know how much.

I guess this will require adding a line:
	.create = cgroup_create
line to the:
	static struct file_operations cgroup_file_operations = {
initialization in kernel/cgroup.c, and a cgroup_create() routine
in kernel/cgroup.c, that calls an optional per-cgroup-subsystem
create routine, that, in the case of cpusets, is willing to create
one of these irqs.N.name files, in the top cpuset, if all looks
right.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
