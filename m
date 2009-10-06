Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbZJFX1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbZJFX1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933499AbZJFX1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:27:32 -0400
Received: from ozlabs.org ([203.10.76.45]:54241 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbZJFX1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:27:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/19] stop_machine: reimplement without using workqueue
Date: Tue, 6 Oct 2009 20:06:58 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-8-git-send-email-tj@kernel.org>
In-Reply-To: <1254384558-1018-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062006.59755.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009 05:39:06 pm Tejun Heo wrote:
> stop_machine() is the only user of RT workqueue.  Reimplement it using
> kthreads directly and rip RT support from workqueue.  This is in
> preparation of concurrency managed workqueue.

Seems reasonable, but:

>  void stop_machine_destroy(void)
>  {
> +	get_online_cpus();
>  	mutex_lock(&setup_lock);

Did you test hotplug cpu after this change?  Maybe this works fine, but it's
always the one we break when we play with this code :(

Thanks!
Rusty.
