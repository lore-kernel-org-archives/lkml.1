Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbXGVIRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbXGVIRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXGVIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:17:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44646 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXGVIRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=krw39DhHFjmPumGBZxC8l9rRIqrjjxqzFm1LTnGemEm1Hw9kAM57jHw75zWxL3aLy5PpDD8zmtLPR/wOczuLMc+Kh/shvZk2RoAwjkIsSzyG8LxzgVoCkDXcNZI8xnQk81h1SAA5FOEroeKxKyASSeoFeE+UEwyFtAav5D+TXFU=
Message-ID: <86802c440707220117x1ce64d1asfac29747a1d81710@mail.gmail.com>
Date: Sun, 22 Jul 2007 01:17:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.99.0707220104550.6665@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
	 <alpine.DEB.0.99.0707220104550.6665@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, David Rientjes <rientjes@google.com> wrote:
> On Sat, 21 Jul 2007, Yinghai Lu wrote:
>
> > [PATCH 3/3] x86_64: offset apicid_to_node before use it before
> > init_cpu_to_node
> >
>
> Does this preserve the correct fake apicid_to_node mapping for the
> emulated case such as numa=fake=32?
>
+void __init update_apicid_to_node(void)
+{
+       /*
+        * let modify apicid_to_node array when boot_cpu_id !=0
+        * apicid_to_node[0] != NUMA_NODE
+        */
+
+       int i;
+
+       /* there is no apic id offset */
+       if (!boot_cpu_id)
+               return;
+
+       /* check if it is already updated */
+       if (apicid_to_node[0] == NUMA_NO_NODE)
+               return;

boot_cpu_id (bsp apic id ) is 0 under fake numa case?

or need to add some exit for fake numa mode.

YH
