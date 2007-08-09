Return-Path: <linux-kernel-owner+w=401wt.eu-S936462AbXHIAu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936462AbXHIAu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbXHIAus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:50:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:53658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbXHIAur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:50:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Aaron Durbin" <adurbin@google.com>
Subject: Re: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Date: Thu, 9 Aug 2007 02:50:43 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070808231719.GA7101@google.com> <200708090226.24002.ak@suse.de> <8f95bb250708081744le5e5216k13087d05211a4056@mail.gmail.com>
In-Reply-To: <8f95bb250708081744le5e5216k13087d05211a4056@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708090250.43467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I was thinking along the same lines as well, but I really didn't know how
> important all that code was for waiting for the next irq slice. I'm not time
> expert, but I would imagine we would resynchronize correctly in the future after
> this code path?

The idea is to just have the apic timers roughly at the same times + some fixed
offset as the main timer.  Otherwise e.g. add_timer could jitter up to a jiffie
regarding the jiffies counter. But long term drift will destroy the synchronization 
anyways.

I guess i'll send it in anyways for .23; it would be too risky to change anything 
radical in this area that late. Then later it can be revisited.

-Andi 


