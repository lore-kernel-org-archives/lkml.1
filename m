Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbXLDJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbXLDJXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXLDJXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:23:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbXLDJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:23:04 -0500
Date: Tue, 4 Dec 2007 01:23:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef
 CONFIG_SYSCTL
Message-Id: <20071204012301.4349bbd0.akpm@linux-foundation.org>
In-Reply-To: <475516B6.5000504@openvz.org>
References: <475008F5.3000506@openvz.org>
	<475009FA.20409@openvz.org>
	<20071203133844.40804dab.akpm@linux-foundation.org>
	<475516B6.5000504@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 11:58:30 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> >> +#ifdef CONFIG_SYSCTL
> >>  	register_sysctl_table(sys_table);
> >> +#endif
> >>  
> >>  	dquot_cachep = kmem_cache_create("dquot",
> >>  			sizeof(struct dquot), sizeof(unsigned long) * 4,
> > 
> > We should avoid the ifdefs around the register_sysctl_table() call.
> > 
> > At present the !CONFIG_SYSCTL implementation of register_sysctl_table() is
> > a non-inlined NULL-returning stub.  All we have to do is to inline that stub
> > then these ifdefs can go away.
> 
> What if some code checks for the return value to be not-NULL? In case
> CONFIG_SYSCTL=n this code will always think, that the registration failed.

The stub function should return success?
