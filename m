Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbXGXPSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbXGXPSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXGXPSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:18:46 -0400
Received: from gw.goop.org ([64.81.55.164]:54880 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbXGXPSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:18:46 -0400
Message-ID: <46A61821.3070703@goop.org>
Date: Tue, 24 Jul 2007 08:17:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       jbeulich@novell.com, zach@vmware.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap write-protected
 kernel text
References: <20070720532.949522000@suse.de> <20070720153246.6597614E79@wotan.suse.de> <1185257169.1803.213.camel@localhost.localdomain> <20070724135750.GD26634@Krystal>
In-Reply-To: <20070724135750.GD26634@Krystal>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hi Rusty,
>
> Good catch. I also still wonder why alternative (except alternative smp,
> which is ok) and paravirt patching functions are not marked __init. I really
> hope they are never used when NMI, MCE are enabled or when threads may
> have been preempted in the site being patched, or it could result in an
> illegal instruction.
>   

We need to patch modules at load time.  Presumably an NMI/MCE handler
will not depend on code in a being-loaded module.

    J
