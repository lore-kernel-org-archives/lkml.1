Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbYHNWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbYHNWFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHNWFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:05:16 -0400
Received: from gw.goop.org ([64.81.55.164]:60918 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYHNWFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:05:15 -0400
Message-ID: <48A4AC01.7040402@goop.org>
Date: Thu, 14 Aug 2008 15:04:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
References: <1218697362.26014.9.camel@localhost.localdomain> <Pine.LNX.4.64.0808141347480.11013@blonde.site> <48A48879.2000309@goop.org> <Pine.LNX.4.64.0808142104080.29719@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808142104080.29719@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> As you can see, I'm still groping towards the right answer.
> The driver probably needs to provide its own backing_dev_info
> (or point to a suitable default), and its own address_space_ops,
> and perhaps more (there should be examples elsewhere).  But whether
> it is actually wrong, or whether I was wrong to mess it up, I've
> not yet decided.
>   

My understanding is that the driver is doing something a bit clever:  it 
uses the page dirty flags to determine which parts of the framebuffer 
have been written to, and uses that information to minimize the amount 
of stuff that needs to be copied out.  The writes to the pages are not 
expected to generate actual page faults.

But I haven't really looked at it closely, and I'm not at all familiar 
with the vm at this layer.  I'm not sure how it actually allocates the 
framebuffer memory for example (vmalloc?  incrementally on faults?).  
I'm hoping Markus will leap in, since wrote this stuff.  Or, gasp, I'll 
read the code myself.

> An additional useful input would be: what happens if you replace
> that /dev/fb0 by a symlink /dev/fb0 pointing to an fb0 device node in
> one of your disk filesystems?  I rather expect that to cause the same
> trouble, which would argue that the driver is wrong and shmem right.
>   

I don't follow. Do you mean make /dev/fb0 a plain file on a filesystem?  
Or make it a disk device node?  Something else?

    J

