Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZCBBzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZCBBzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbZCBBzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:55:00 -0500
Received: from gw.goop.org ([64.81.55.164]:48912 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZCBBy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:54:59 -0500
Message-ID: <49AB3C70.7090701@goop.org>
Date: Sun, 01 Mar 2009 17:54:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: brk patches..
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org>	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>	 <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org>	 <49A8F319.3030802@goop.org> <86802c440902281240i11423a95l98e330768ac6ca18@mail.gmail.com> <49AB1FE6.8030300@goop.org> <49AB3031.4020500@kernel.org> <49AB316E.4000009@zytor.com> <49AB3377.40904@goop.org> <49AB3805.6060109@zytor.com>
In-Reply-To: <49AB3805.6060109@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> (To be specific: I reshape the guest e820 table so that it doesn't have
>> memory in any forbidden areas of the host e820 table.  That may require
>> moving the pseudo-physical address of pages into a new overflow e820
>> entry, which would also require allocating pages for the p2m radix tree.)
>>
>>     
>
> Isn't that the domain builder's job?
>   

No.  It just provides a flat memory map from 0-max_pfn.  I want to avoid 
the overlap between pseudo-phys and machine memory so that the resource 
manager doesn't get confused by overlapping ranges, and so that it 
places the pci window in the same place as native.

    J
