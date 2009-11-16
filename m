Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZKPXEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZKPXEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZKPXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:04:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63465 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZKPXEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:04:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rnoi0Glflp/Z1ciBjdPaOtnjSi8MCeE8BEQnNgar6qar2Eokr9ruIwH5iDiP+tGNn8
         OeoKUEiYxK1sdlfwFAQd2ndnJfGRig6TdKIYRDz2LNYML3pqhvBMJlm5OSKc20skdYx5
         sgU2QPcn8EKzIucKUGYB0lBTW/PTyVAk0a8qI=
Date: Tue, 17 Nov 2009 00:04:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, Andi Kleen <ak@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 01/21] workqueue: fix race condition in
	schedule_on_each_cpu()
Message-ID: <20091116230427.GD5293@nowhere>
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258391726-30264-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 02:15:06AM +0900, Tejun Heo wrote:
> Commit 65a64464349883891e21e74af16c05d6e1eeb4e9 which allows
> schedule_on_each_cpu() to be called from keventd added a race
> condition.  schedule_on_each_cpu() may race with cpu hotplug and end
> up executing the function twice on a cpu.
> 
> Fix it by moving direct execution into the section protected with
> get/put_online_cpus().  While at it, update code such that direct
> execution is done after works have been scheduled for all other cpus
> and drop unnecessary cpu != orig test from flush loop.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---


Shouldn't this patch go to .32 ?
This looks like an important fix.

