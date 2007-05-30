Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXE3WYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXE3WYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761936AbXE3WYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:24:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:33392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761926AbXE3WYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:24:31 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: GFP_DMA32 and PAE x86 machines
Date: Thu, 31 May 2007 00:24:25 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Linus Torvalds" <torvalds@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com> <465DECD7.8030104@zytor.com> <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com>
In-Reply-To: <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310024.25937.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2007 00:07:45 Dave Airlie wrote:
> Depending on split all lowmem is below 1GB which isn't exactly
> optimal, I'd llike all 4GB for DMA.

Well it would be for a quite specialized limited use case: 
- Memory the kernel doesn't need to map (after all kmap is evil) 
- You need more than 500MB or so.
- 32bit kernel and user cannot run 64bit kernel
- Machine has >3GB of RAM 

Is there clear evidence that is a common issue? If it is just a "would
be nice to have in theory" the cost of doing a GFP_DMA32 for i386 would be
probably not worth doing it. If it's a common issue it might be 
considered, although the "here's a nickle. buy yourself a 64bit CPU"
strategy would also sound attractive. 

Please give a very very strong rationale why you want it. Did you actually
run into such a situation yourself yet?

-Andi
