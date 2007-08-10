Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbXHJJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbXHJJXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbXHJJXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:23:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60004 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbXHJJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:23:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + sysctl-error-on-bad-sysctl-tables.patch added to -mm tree
References: <200708092211.l79MBoVR022139@imap1.linux-foundation.org>
	<20070810080952.GA6670@localhost.sw.ru>
Date: Fri, 10 Aug 2007 03:22:23 -0600
In-Reply-To: <20070810080952.GA6670@localhost.sw.ru> (Alexey Dobriyan's
	message of "Fri, 10 Aug 2007 12:09:52 +0400")
Message-ID: <m1k5s3zquo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:

> It gives false positive on kernel.pty.nr:
>
> 	sysctl table check failed: /kernel/pty/nr .1.62.2 No data
>
> However, ->data is set in unix98_pty_init().

It's a race.  

Data isn't set until after we enable the sysctl subsystem.

In practice I doubt it matters but I think would rather fix
that one case (by using register_sysctl_table) then not have
the check.

Eric
