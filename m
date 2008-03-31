Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYCaO43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYCaO43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYCaO4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:56:21 -0400
Received: from gw.goop.org ([64.81.55.164]:60536 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbYCaO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:56:20 -0400
Message-ID: <47F0FB5F.2000908@goop.org>
Date: Mon, 31 Mar 2008 07:55:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/3] xen: Fix oops when mapping/unmapping addr above 1Gb
References: <1206722297-11763-1-git-send-email-markmc@redhat.com> <20080331131442.GF14636@elte.hu>
In-Reply-To: <20080331131442.GF14636@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mark McLoughlin <markmc@redhat.com> wrote:
>
>   
>>         In Fedora rawhide we're currently seeing oopses whenever a 
>> processes dlopen()s a library which prelink() has previously relocated 
>> above 1Gb. Some more details at:
>>
>>   https://bugzilla.redhat.com/436453
>>
>>         The issue seems to be that during xen_pgd_pin(), we only pin 
>> PTE pages, but xen's release_pmd() tries to unpin PMD pages too.
>>
>>         The following series of patches is against the latest x86 
>> tree.
>>     
>
> thanks, i've picked them up to get them tested - but it would be nice to 
> have an ack from Jeremy as well. This seems like v2.6.25 material as 
> well, right?

Didn't I reply?  Anyway, the patch looks good.  It's definitely 2.6.25 
material; its fallout from the changes I did to dynamically 
allocate/deallocate pmds rather than always do them with the pgd.

    J
