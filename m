Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYKGB1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYKGB1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYKGB04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:26:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbYKGB04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:26:56 -0500
Date: Thu, 6 Nov 2008 17:26:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task
 directories
Message-Id: <20081106172617.dd51d0af.akpm@linux-foundation.org>
In-Reply-To: <m1abcd2kqk.fsf@frodo.ebiederm.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 02:48:35 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> +void proc_shrink_automounts(void)
> +{
> +	struct list_head *list = &proc_automounts;
> +
> +	mark_mounts_for_expiry(list);
> +	mark_mounts_for_expiry(list);

Strange.  In case the first attempt didn't work?

> +	if (list_empty(list))
> +		return;
> +
> +	schedule_delayed_work(&proc_automount_task, proc_automount_timeout);
> +}
