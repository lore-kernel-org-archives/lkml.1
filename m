Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbXJISqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbXJISqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXJISqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:46:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39265 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754678AbXJISqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:46:14 -0400
Date: Tue, 9 Oct 2007 11:46:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <20071009161328.GA6470@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Akinobu Mita wrote:

> This patch removes init_alloc_cpu_cpu() from cpu hotplug notifier. But
> call it for each possible CPUs not only online CPUs at initialization time.

Could you check if a per cpu structure has already been allocated and then 
simply skip the call to init? Otherwise we end up with lots of per cpu 
structures for cpus that will never show up. 

if (!get_cpu_slab(s, cpu))
	init_alloc_cpu_cpu( ...)

