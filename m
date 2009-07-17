Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZGQGDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZGQGDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbZGQGDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:03:19 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:59551 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZGQGDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d6s6RTSureXyf8mC9gOYvow1nRyO6HVLZkzZA0kMYi8mQrbTXWG0zNCQhzPIGvBCUE
         ktXBytaq7C4V/5bRPWsMKY+dr8E2P2AkcpOHKZSjBqKPN+33YaKwc2NcOuNQ1wUJuuM9
         rEGJdFrpmLVIDiT8P/gPeBWUQRxUQ2Z9U4Se4=
MIME-Version: 1.0
In-Reply-To: <20090717143818.38B7.E1E9C6FF@jp.fujitsu.com>
References: <20090717135847.38B3.E1E9C6FF@jp.fujitsu.com>
	 <3877989d0907162233x6e5874e5r3b679454160a6077@mail.gmail.com>
	 <20090717143818.38B7.E1E9C6FF@jp.fujitsu.com>
Date: Fri, 17 Jul 2009 14:03:18 +0800
Message-ID: <3877989d0907162303k26bfd293n2edb39c8206f8be8@mail.gmail.com>
Subject: Re: [RFC patch] delete improper hot pluggable code of memory affinity
From: Luming Yu <luming.yu@gmail.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 1:52 PM, Yasunori Goto<y-goto@jp.fujitsu.com> wrote:
>> Without a fix like my proposal, I have seen NUMA configure disabled by
>> kernel (due to the code the patch deletes) on a system with Enabled
>> bit set , and Hotplug-able bit cleared, and
>> CONFIG_MEMORY_HOTPLUG_SPARSE disabled.
>
> Ok. I guess that save_add_info() was to check percentage of
> reserve area when CONFIG_MEMORY_HOTPLUG_RESERVE is set.
> Its code was removed at 2.6.25, save_add_info() may be garbage now.
>
> However, I have one question now.
>
>>> -    if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
>>> -            update_nodes_add(node, start, end);
>>> -            /* restore nodes[node] */
>>> -            *nd = oldnode;
>>> -            if ((nd->start | nd->end) == 0)
>>> -                    node_clear(node, nodes_parsed);
>>> -     }
>
> I don't understand why you remove this code. could you tell me why?

Good question. This is exactly the place I'm puzzled too.
Without delete this code, I still see one fake node instead of 4 real node...
I think a flow up patch is needed here...
