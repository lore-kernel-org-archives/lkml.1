Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbXFDTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbXFDTcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbXFDTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:31:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41894 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760846AbXFDTbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:31:55 -0400
Date: Mon, 4 Jun 2007 12:31:51 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-Id: <20070604123151.4db007a6.pj@sgi.com>
In-Reply-To: <20070604191412.GA901@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What you describe, Serge, sounds like semantics carried over from cpusets.

Serge wrote:
> A task can't join a cpuset unless 'cpus' and 'mems' are set.

Yup - don't want to run a task in a cpuset that lacks cpu, or lacks
memory.  Hard to run without those.

> These don't seem to automatically inherit the parent's values

Yup - early in the life of cpusets, a created cpuset inherited the cpus
and mems of its parent.  But that broke the exclusive property big
time.  You will recall that a cpu_exclusive or mem_exclusive cpuset
cannot overlap the cpus or memory, respectively, of any of its sibling
cpusets.

So we changed it to creating new cpusets empty of cpus or memory.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
