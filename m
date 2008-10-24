Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYJXLGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYJXLGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYJXLF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:05:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYJXLF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:05:57 -0400
Date: Fri, 24 Oct 2008 13:06:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: sukadev@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       daniel@hozac.com, Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 'kill sig -1' must only apply to caller's namespace
Message-ID: <20081024110646.GA10521@redhat.com>
References: <20081023154928.GA1044@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023154928.GA1044@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, sukadev@linux.vnet.ibm.com wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1144,7 +1144,8 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
>  		struct task_struct * p;
>
>  		for_each_process(p) {
> -			if (p->pid > 1 && !same_thread_group(p, current)) {
> +			if (task_pid_vnr(p) > 1 &&
> +					!same_thread_group(p, current)) {

Thanks Sukadev!

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Oleg.

