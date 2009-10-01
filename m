Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZJANAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZJANAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZJANAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:00:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZJANAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:00:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1254384558-1018-7-git-send-email-tj@kernel.org>
References: <1254384558-1018-7-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [PATCH 06/19] acpi: use queue_work_on() instead of binding workqueue worker to cpu0
Date: Thu, 01 Oct 2009 13:57:31 +0100
Message-ID: <9997.1254401851@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> -	kacpid_wq = create_singlethread_workqueue("kacpid");
> -	bind_workqueue(kacpid_wq);
> -	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
> -	bind_workqueue(kacpi_notify_wq);
> -	kacpi_hotplug_wq = create_singlethread_workqueue("kacpi_hotplug");
> -	bind_workqueue(kacpi_hotplug_wq);
> +	kacpid_wq = create_workqueue("kacpid");
> +	kacpi_notify_wq = create_workqueue("kacpi_notify");
> +	kacpi_hotplug_wq = create_workqueue("kacpi_hotplug");

Doesn't that then create one worker thread per CPU and then eschew all but
those attached to CPU 0?  Sounds excessive, but presumably you deal with that
in later patches.

David
