Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZLOWms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZLOWms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZLOWmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:42:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZLOWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:42:46 -0500
Message-ID: <4B2810D6.9030309@zytor.com>
Date: Tue, 15 Dec 2009 14:42:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>	<1257813017-28598-2-git-send-email-cascardo@holoscopio.com>	<1257813017-28598-3-git-send-email-cascardo@holoscopio.com>	<4AF8B4FF.9050405@zytor.com>	<20091111153632.944a255c.akpm@linux-foundation.org> <20091215143446.8b6a7e57.akpm@linux-foundation.org>
In-Reply-To: <20091215143446.8b6a7e57.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 02:34 PM, Andrew Morton wrote:
>>>>
>>>> The proposed solution uses the not yet reserved range from 64 to 127. If
>>>> more devices are needed, we may push 64 to 16.
>>>>
>>>
>>> Again, why not push these up above 256?
>>>
>>
>> I merged this patch, but made a note-to-self that there are remaining
>> open issues..
> 
> And nothing else happened.  Can we revisit this please?
> 

There seem to be people still worried about breaking userspace with
majors/minors >= 256.  I'm starting to think it is time to actually
break userspace, and dynamic majors/minors seem as good as any place to
start, especially since they by definition has to be managed by
something like udev.  We have had large dev_t for something like six
years now, and most pieces of software isn't affected at all -- only the
stuff that manages /dev.

	-hpa
