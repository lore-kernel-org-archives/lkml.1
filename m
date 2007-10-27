Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbXJ0PXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbXJ0PXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXJ0PXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:23:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXJ0PXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:23:04 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: linux-audit@redhat.com
Subject: Re: [PATCH] audit: clear thread flag for new children
Date: Sat, 27 Oct 2007 10:21:39 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, viro@ftp.linux.org.uk
References: <20071026204228.GA1519@suse.de>
In-Reply-To: <20071026204228.GA1519@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271021.42093.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 04:42:28 pm Tony Jones wrote:
> Thread flag TIF_SYSCALL_AUDIT is not cleared for new children when audit
> context creation has been disabled (auditctl -e0). This can cause new
> children forked from a parent created when audit was enabled to not take
> the fastest syscall path thru entry.S

This came up almost 2 years ago:

https://www.redhat.com/archives/linux-audit/2005-September/msg00048.html

The problem is that removing that flag makes the children unauditable in the 
future. The only place that flag gets set is during fork. Unless I'm missing 
something, to make all children auditable again would mean stopping all 
processes and or'ing that flag into all thread info areas. I do not want to 
propose that patch to LKML.  :)

-Steve
