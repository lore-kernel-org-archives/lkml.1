Return-Path: <linux-kernel-owner+w=401wt.eu-S934109AbZGQGVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109AbZGQGVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbZGQGVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:21:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60462 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934074AbZGQGVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:21:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Jul 2009 15:20:53 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Luming Yu <luming.yu@gmail.com>
Subject: Re: [RFC patch] delete improper hot pluggable code of memory affinity
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <3877989d0907162303k26bfd293n2edb39c8206f8be8@mail.gmail.com>
References: <20090717143818.38B7.E1E9C6FF@jp.fujitsu.com> <3877989d0907162303k26bfd293n2edb39c8206f8be8@mail.gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090717151118.38BC.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jul 17, 2009 at 1:52 PM, Yasunori Goto<y-goto@jp.fujitsu.com> wrote:
> >> Without a fix like my proposal, I have seen NUMA configure disabled by
> >> kernel (due to the code the patch deletes) on a system with Enabled
> >> bit set , and Hotplug-able bit cleared, and
> >> CONFIG_MEMORY_HOTPLUG_SPARSE disabled.
> >
> > Ok. I guess that save_add_info() was to check percentage of
> > reserve area when CONFIG_MEMORY_HOTPLUG_RESERVE is set.
> > Its code was removed at 2.6.25, save_add_info() may be garbage now.
> >
> > However, I have one question now.
> >
> >>> - ? ?if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> >>> - ? ? ? ? ? ?update_nodes_add(node, start, end);
> >>> - ? ? ? ? ? ?/* restore nodes[node] */
> >>> - ? ? ? ? ? ?*nd = oldnode;
> >>> - ? ? ? ? ? ?if ((nd->start | nd->end) == 0)
> >>> - ? ? ? ? ? ? ? ? ? ?node_clear(node, nodes_parsed);
> >>> - ? ? }
> >
> > I don't understand why you remove this code. could you tell me why?
> 
> Good question. This is exactly the place I'm puzzled too.
> Without delete this code, I still see one fake node instead of 4 real node...
> I think a flow up patch is needed here...

In my understanding, here is for the case when the SRAT entry is enabled,
but memory is not connected. (This is why I sent the first mail).
However, here may have a bug yet. 

I would like to test here, but I don't have a real x86-64 machine which can
hot add memory. So, I can just guess now.

Anyway, thanks for your notification. If you have progress about it,
please let me know.

Bye.

-- 
Yasunori Goto 


