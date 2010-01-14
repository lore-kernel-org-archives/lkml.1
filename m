Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544Ab0ANLXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0ANLXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403Ab0ANLXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:23:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab0ANLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:23:47 -0500
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:23:11 +0100
Message-ID: <1263468191.4244.300.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 17:56 +0530, Srikar Dronamraju wrote:
> This patch implements ftrace plugin for uprobes.

Right, like others have said, trace events is a much saner interface.

So the easiest way I can see that working is to register uprobes against
a file (not a pid). Then on creation it uses rmap to find all current
maps of that file and install the probe if there is a consumer for that
map.

Then for each new mmap() of that file, we also need to check if there's
a consumer ready and install the probe.

The existence of the uprobe trace-event would keep a ref on the
dentry/inode, ensuring it remains around or something.

Consumers could be some utrace thing (currently called uprobe -- which
is a misnomer imo), or perf, or ftrace like.



