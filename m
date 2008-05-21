Return-Path: <linux-kernel-owner+w=401wt.eu-S936595AbYEUSSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936595AbYEUSSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbYEUSSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:18:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38951 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbYEUSSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:18:43 -0400
Message-ID: <483467B4.1060601@us.ibm.com>
Date: Wed, 21 May 2008 13:19:32 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@sunset.davemloft.net>,
       systemtap@sources.redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org, linux-nfs@vger.kernel.org
Subject: Re: Re: [PATCH] usb-storage: don't call utsname()
References: <20080521123700.GA8770@infradead.org>	<Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org> <20080521180957.GA17598@kroah.com>
In-Reply-To: <20080521180957.GA17598@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, May 21, 2008 at 01:51:17PM -0400, Alan Stern wrote:
>   
>> This patch (as1100) replaces the core-kernel function call to utsname()
>> in usb-storage with the UTS_RELEASE macro.  It's used only for warning
>> about extra unusual_devs entries.
>>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>>     
>
> Why?  With this change, if you change the version number, the file will
> have to be rebuilt.  Without the change, the file will not need to be
> rebuilt, right?
>
> I thought that was why this change was made a while ago, to prevent
> things from having to be rebuilt that didn't need to be
>   
I agree - what was wrong with utsname->release ... it seems odd to 
statically build the kernel's version
number into a module - it should be something we should be able to query 
(and it shouldn't change without
reboot so accessing it is not racy).  Access to other fields in the 
structure (nodename, domainname etc.) might
need to be included in a macro but I didn't see one in utsname.h for this.
