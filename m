Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbYCFPIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbYCFPIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbYCFPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:08:22 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55803 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYCFPIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:08:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net (v2)
References: <47CFB6CA.8090001@openvz.org>
Date: Thu, 06 Mar 2008 08:06:40 -0700
In-Reply-To: <47CFB6CA.8090001@openvz.org> (Pavel Emelyanov's message of "Thu,
	06 Mar 2008 12:18:02 +0300")
Message-ID: <m1tzjj28ov.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

> Current /proc/net is done with so called "shadows", but current
> implementation is broken and has little chances to get fixed.
>
> The problem is that dentries subtree of /proc/net directory has
> fancy revalidation rules to make processes living in different
> net namespaces see different entries in /proc/net subtree, but
> currently, tasks see in the /proc/net subdir the contents of any
> other namespace, depending on who opened the file first.
>
> The proposed fix is to turn /proc/net into a symlink, which points
> to /proc/self/net, which in turn shows what previously was in
> /proc/net - the network-related info, from the net namespace the
> appropriate task lives in.
>
> # ls -l /proc/net
> lrwxrwxrwx  1 root root 8 Mar  5 15:17 /proc/net -> self/net
>
> In other words - this behaves like /proc/mounts, but unlike
> "mounts", "net" is not a file, but a directory.
>
> Fixed a task_struct leak in get_proc_task_net, pointed out by Paul.
>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
