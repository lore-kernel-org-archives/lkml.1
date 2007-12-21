Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbXLUNSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbXLUNSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXLUNSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:18:44 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59736 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXLUNSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:18:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [Jan Beulich] [PATCH] constify tables in kernel/sysctl_check.c
References: <m1r6hh6jsy.fsf@ebiederm.dsl.xmission.com>
	<20071221023031.GA23320@redhat.com>
Date: Fri, 21 Dec 2007 06:17:18 -0700
In-Reply-To: <20071221023031.GA23320@redhat.com> (Dave Jones's message of
	"Thu, 20 Dec 2007 21:30:31 -0500")
Message-ID: <m14pec6vc1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Thu, Dec 20, 2007 at 04:14:05PM -0700, Eric W. Biederman wrote:
>
>  > Remains the question whether it is intended that many, perhaps even
>  > large, tables are compiled in without ever having a chance to get used,
>  > i.e. whether there shouldn't #ifdef CONFIG_xxx get added.
>
>  > -static struct trans_ctl_table trans_net_ax25_param_table[] = {
>  > +static const struct trans_ctl_table trans_net_ax25_table[] = {
>
> we lost the _param, which will cause a duplicate definition with ..
>  
>  > -static struct trans_ctl_table trans_net_ax25_table[] = {
>  > +static const struct trans_ctl_table trans_net_ax25_table[] = {
>
> cut-n-paste thinko ?

Thanks, for catching that.

Anyway this patch looks sound in principle but I expect it might conflict
with the bug fix Andrew just merged.

Eric
