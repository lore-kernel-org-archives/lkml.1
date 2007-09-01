Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbXIALTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbXIALTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 07:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXIALTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 07:19:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:42269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbXIALSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 07:18:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: optionally show last exception from/to register contents (v2)
Date: Sat, 1 Sep 2007 13:18:31 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <46D418AF.76E4.0078.0@novell.com>
In-Reply-To: <46D418AF.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011318.31520.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 12:44:31 Jan Beulich wrote:
> .. when dumping register state. This is particularly useful when gcc
> managed to tail-call optimize an indirect call which happens to hit a
> NULL (or otherwise invalid) pointer.

I added it, with a warning in the documentation and changelog

Also all the other patches except for the #DF one. Thanks.

BTW I think there is a reasonable cheap way to avoid the interrupt race: 

If pda->irqcount was split into two 16bit words and irq entry code increases the upper 
16bit word (that should be nearly free because because both are in L1 cache; 
with some luck the CPU can even dual-issue). Then the traps code could save
the irq count early and then in the no_context case disable interrupts,
compare and only print LER if there were no interrupts inbetween.

-Andi 


