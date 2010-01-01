Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189Ab0AAWWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0AAWWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 17:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873Ab0AAWWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 17:22:39 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58894 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0AAWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 17:22:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kZF/T7yMqfpHXykA7HvQPxfOowukmqXZ2yQtSGh1kd6ooYagA+PSs7T/7nYwpq96GA
         Mu0fwy/+tUWfWbapDXxn3MmCzeC+/oDHtSNHG2zaKfAv9Ev9JNlIDdpQxk3zWNZ5aRKB
         oTIK8zITqGxypalb45PDrD4qcfOiEdrQ9T+FA=
MIME-Version: 1.0
In-Reply-To: <4B3E51FC.9000502@xenontk.org>
References: <4B3E51FC.9000502@xenontk.org>
Date: Fri, 1 Jan 2010 14:22:38 -0800
X-Google-Sender-Auth: a74e2e9ff58ae0c7
Message-ID: <86802c441001011422n435545cy1b69ff155b05a1a6@mail.gmail.com>
Subject: Re: [Regression] 2.6.33-rc2 - pci: Commit e0cd516 causes OOPS
From: Yinghai Lu <yinghai@kernel.org>
To: davidjon@xenontk.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rusty Russell <rusty@rustcorp.com.au>, andreas.herrmann3@amd.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 1, 2010 at 11:50 AM, David John <davidjon@xenontk.org> wrote:
> Hi All,
>
> Commit e0cd516 causes an null pointer dereference when reading from the
> sysfs attributes local_cpu* on Intel machines with no ACPI NUMA
> proximity info, since dev->numa_node gets set to -1 for all PCI devices,
> which then gets passed to cpumask_of_node.
>
> The patch following this mail fixes the problem for x86. Perhaps a more
> thorough solution would be to fix the PCI layer to set the node
> information for devices to zero rather than -1 (Since if CONFIG_NUMA=y
> we have node 0)? I don't know whether it is safe / correct to do this.

no.

1. -1, mean calling code will use node that code is running on.
2. the system that have two or more nodes, and more peer root buses.
if the first node doesn't have RAM installed, no node0 then.

YH
