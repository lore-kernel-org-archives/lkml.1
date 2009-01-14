Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZANBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZANBqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZANBqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:46:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZANBqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:46:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=CoFGGUuXtl1jYsPqmq9CSL0fff4F7Fbh9SgVVH7mi7DQDnSdwg3dmVm+2C5xld6cw
	eOQz5pAGrcloo8qlHAJCg==
MIME-Version: 1.0
In-Reply-To: <20090107184116.18062.8379.sendpatchset@localhost.localdomain>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
	 <20090107184116.18062.8379.sendpatchset@localhost.localdomain>
Date: Tue, 13 Jan 2009 17:45:54 -0800
Message-ID: <6599ad830901131745t704428dav6fbf69aa315285b1@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] Memory controller soft limit documentation
From: Paul Menage <menage@google.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.143
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 10:41 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> -7. TODO
> +7. Soft limits
> +
> +Soft limits allow for greater sharing of memory. The idea behind soft limits
> +is to allow control groups to use as much of the memory as needed, provided
> +
> +a. There is no memory contention
> +b. They do not exceed their hard limit
> +
> +When the system detects memory contention (through do_try_to_free_pages(),
> +while allocating), control groups are pushed back to their soft limits if
> +possible. If the soft limit of each control group is very high, they are
> +pushed back as much as possible to make sure that one control group does not
> +starve the others.

Can you give an example here of how to implement the following setup:

- we have a high-priority latency-sensitive server job A and a bunch
of low-priority batch jobs B, C and D

- each job *may* need up to 2GB of memory, but generally each tends to
use <1GB of memory

- we want to run all four jobs on a 4GB machine

- we don't want A to ever have to wait for memory to be reclaimed (as
it's serving latency-sensitive queries), so the kernel should be
squashing B/C/D down *before* memory actually runs out.

Is this possible with the proposed hard/soft limit setup? Or do we
need some additional support for keeping a pool of pre-reserved free
memory available?

Paul
