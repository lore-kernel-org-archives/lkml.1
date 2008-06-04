Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbYFDTmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbYFDTmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbYFDTm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:42:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36619 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759001AbYFDTm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:42:26 -0400
Date: Wed, 4 Jun 2008 14:42:21 -0500
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and
 mems_allowed after CPU/NODE offline/online
Message-Id: <20080604144221.de09b709.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.10.0806041232190.22192@chino.kir.corp.google.com>
References: <4845F864.8060102@cn.fujitsu.com>
	<6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com>
	<6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com>
	<20080604122227.a092e70e.pj@sgi.com>
	<alpine.DEB.1.10.0806041149560.21323@chino.kir.corp.google.com>
	<20080604142540.6fa2bcc3.pj@sgi.com>
	<alpine.DEB.1.10.0806041232190.22192@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> No, because sched_setaffinity() can still move the threads.

Good point.

How about also adding this check (NULL mm and struct subset cpus)
to sched_setaffinity?

Granted, this pair of checks, in cpusets and sched_setaffinity,
is getting to be a little more work than the PF_* flag.

I guess one question would be how hard we want to work to avoid
consuming another PF_* flag.  I thought they were scarce, but I
might be wrong.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
