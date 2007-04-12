Return-Path: <linux-kernel-owner+w=401wt.eu-S2992436AbXDLKHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992436AbXDLKHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946119AbXDLKHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:07:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60941 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945997AbXDLKHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:07:51 -0400
Date: Thu, 12 Apr 2007 11:10:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Steve Beattie <sbeattie@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: Re: [AppArmor 03/41] Remove redundant check from proc_sys_setattr()
Message-ID: <20070412111021.3bb947e0@the-village.bc.nu>
In-Reply-To: <20070412090836.943689000@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090836.943689000@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 02:08:12 -0700
jjohansen@suse.de wrote:

> notify_change() already calls security_inode_setattr() before
> calling iop->setattr.

This is a behaviour change on all of these and limits some behaviour of
existing established security modules

When inode_change_ok is called it has side effects. This includes
clearing the SGID bit on attribute changes caused by chmod. If you make
this change the results of some rulesets may be different before or
after the change is made.

I'm not saying the change is wrong but it does change behaviour so that
needs looking at closely (ditto all other attribute twiddles)

Alan



