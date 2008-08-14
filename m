Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYHNXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYHNXOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYHNXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:14:23 -0400
Received: from saeurebad.de ([85.214.36.134]:46596 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYHNXOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:14:23 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
References: <1218697362.26014.9.camel@localhost.localdomain>
	<Pine.LNX.4.64.0808141347480.11013@blonde.site>
	<48A48879.2000309@goop.org>
	<Pine.LNX.4.64.0808142104080.29719@blonde.site>
	<48A4AC01.7040402@goop.org>
Date: Fri, 15 Aug 2008 01:13:59 +0200
In-Reply-To: <48A4AC01.7040402@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 14 Aug 2008 15:04:49 -0700")
Message-ID: <871w0r5gw8.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Hugh Dickins wrote:
>> As you can see, I'm still groping towards the right answer.
>> The driver probably needs to provide its own backing_dev_info
>> (or point to a suitable default), and its own address_space_ops,
>> and perhaps more (there should be examples elsewhere).  But whether
>> it is actually wrong, or whether I was wrong to mess it up, I've
>> not yet decided.
>>   
>
> My understanding is that the driver is doing something a bit clever:
> it uses the page dirty flags to determine which parts of the
> framebuffer have been written to, and uses that information to
> minimize the amount of stuff that needs to be copied out.  The writes
> to the pages are not expected to generate actual page faults.
>
> But I haven't really looked at it closely, and I'm not at all familiar
> with the vm at this layer.  I'm not sure how it actually allocates the
> framebuffer memory for example (vmalloc?  incrementally on faults?).
> I'm hoping Markus will leap in, since wrote this stuff.  Or, gasp,
> I'll read the code myself.
>
>> An additional useful input would be: what happens if you replace
>> that /dev/fb0 by a symlink /dev/fb0 pointing to an fb0 device node in
>> one of your disk filesystems?  I rather expect that to cause the same
>> trouble, which would argue that the driver is wrong and shmem right.
>>   
>
> I don't follow. Do you mean make /dev/fb0 a plain file on a
> filesystem?  Or make it a disk device node?  Something else?

Creating a device node on a different filesystem to see if the driver
only worked with the safe shmem set_page_dirty and now breaks due to
exposure to the generic version.  Or if the driver works with the
generic version through other mappings and the shmem code screws it up
somewhere else.

	Hannes
