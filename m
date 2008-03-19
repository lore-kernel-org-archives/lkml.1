Return-Path: <linux-kernel-owner+w=401wt.eu-S966566AbYCSWlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966566AbYCSWlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764767AbYCSVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:12:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936502AbYCSVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:12:04 -0400
Date: Wed, 19 Mar 2008 14:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       morgan@kernel.org, buraphalinuxserver@gmail.com,
       lcapitulino@mandriva.com.br, stable@kernel.org
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill() (-git)
Message-Id: <20080319141112.02981daf.akpm@linux-foundation.org>
In-Reply-To: <20080319165635.GH5935@sergelap.ibm.com>
References: <20080319165635.GH5935@sergelap.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 11:56:35 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> (resending once against -git.  I had sent against -stable in
> http://lkml.org/lkml/2008/2/28/225.  Without this patch,
> atd is broken at least on some distros.)

So this fix is needed in 2.6.24.x?

> The original justification for cap_task_kill() was as follows:
> 
> 	check_kill_permission() does appropriate uid equivalence checks.
> 	However with file capabilities it becomes possible for an
> 	unprivileged user to execute a file with file capabilities
> 	resulting in a more privileged task with the same uid.
> 
> However now that cap_task_kill() always returns 0 (permission
> granted) when p->uid==current->uid, the whole hook is worthless,
> and only likely to create more subtle problems in the corner cases
> where it might still be called but return -EPERM.  Those cases
> are basically when uids are different but euid/suid is equivalent
> as per the check in check_kill_permission().
> 
> One example of a still-broken application is 'at' for non-root users.

This 2.6.25-rc6 patch doesn't apply correctly to 2.6.24.  I can't find a
*formal* copy of your 2.6.24 patch on stable@kernel.org, so perhaps a
resend for -stable is in order.

