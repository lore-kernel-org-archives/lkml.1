Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbXHJIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbXHJIKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXHJIKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:10:01 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37230 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbXHJIJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:09:58 -0400
Date: Fri, 10 Aug 2007 12:09:52 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: + sysctl-error-on-bad-sysctl-tables.patch added to -mm tree
Message-ID: <20070810080952.GA6670@localhost.sw.ru>
References: <200708092211.l79MBoVR022139@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708092211.l79MBoVR022139@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:11:50PM -0700, akpm@linux-foundation.org wrote:
> Subject: sysctl: Error on bad sysctl tables
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> After going through the kernels sysctl tables several times it has become
> clear that code review and testing is just not effective in prevent
> problematic sysctl tables from being used in the stable kernel.  I certainly
> can't seem to fix the problems as fast as they are introduced.
> 
> Therefore this patch adds sysctl_check_table which is called when a sysctl
> table is registered and checks to see if we have a problematic sysctl table.
> 
> The biggest part of the code is the table of valid binary sysctl entries, but
> since we have frozen our set of binary sysctls this table should not need to
> change, and it makes it much easier to detect when someone unintentionally
> adds a new binary sysctl value.
> 
> As best as I can determine all of the several hundred errors spewed on boot up
> now are legitimate.

It gives false positive on kernel.pty.nr:

	sysctl table check failed: /kernel/pty/nr .1.62.2 No data

However, ->data is set in unix98_pty_init().

