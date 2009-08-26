Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbZHZBUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbZHZBUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932779AbZHZBUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:20:42 -0400
Received: from mail.lang.hm ([64.81.33.126]:33153 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749AbZHZBUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:20:41 -0400
Date: Tue, 25 Aug 2009 18:19:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
In-Reply-To: <20090826004430.GR4300@elf.ucw.cz>
Message-ID: <alpine.DEB.2.00.0908251817390.30426@asgard.lang.hm>
References: <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm>
 <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <4A94812C.5010803@redhat.com> <20090826004430.GR4300@elf.ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Pavel Machek wrote:

>>>>> THESE devices have the property of potentially corrupting blocks being
>>>>> written at the time of the power failure,
>>>>
>>>> this is true of all devices
>>>
>>> Actually I don't think so. I believe SATA disks do not corrupt even
>>> the sector they are writing to -- they just have big enough
>>> capacitors. And yes I believe ext3 depends on that.
>>
>> Pavel, no S-ATA drive has capacitors to hold up during a power failure
>> (or even enough power to destage their write cache). I know this from
>> direct, personal knowledge having built RAID boxes at EMC for years. In
>> fact, almost all RAID boxes require that the write cache be hardwired to
>> off when used in their arrays.
>
> I never claimed they have enough power to flush entire cache -- read
> the paragraph again. I do believe the disks have enough capacitors to
> finish writing single sector, and I do believe ext3 depends on that.

keep in mind that in a powerfail situation the data being sent to the 
drive may be corrupt (the ram gets flaky while a DMA to the drive copies 
the bad data to the drive, which writes it before the power loss gets bad 
enough for the drive to decide there is a problem and shutdown)

you just plain cannot count on writes that are in flight when a powerfail 
happens to do predictable things, let alone what you consider sane or 
proper.

David Lang
