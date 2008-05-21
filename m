Return-Path: <linux-kernel-owner+w=401wt.eu-S937104AbYEUVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937104AbYEUVBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYEUVBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:01:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52581 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbYEUVBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:01:04 -0400
Message-ID: <48348D9B.8090707@us.ibm.com>
Date: Wed, 21 May 2008 16:01:15 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@sunset.davemloft.net>,
       systemtap@sources.redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org, linux-nfs@vger.kernel.org
Subject: Re: Re: [PATCH] usb-storage: don't call utsname()
References: <20080521123700.GA8770@infradead.org>	<Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org>	<20080521180957.GA17598@kroah.com>	<20080521185251.GA783@infradead.org> <20080521193517.GA4905@kroah.com>
In-Reply-To: <20080521193517.GA4905@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, May 21, 2008 at 02:52:51PM -0400, Christoph Hellwig wrote:
>   
>> On Wed, May 21, 2008 at 11:09:57AM -0700, Greg KH wrote:
>>     
>>> Why?  With this change, if you change the version number, the file will
>>> have to be rebuilt.  Without the change, the file will not need to be
>>> rebuilt, right?
>>>       
>> Because thanks to the container patches it utsname fields other than
>> hostname can actually change at runtime now and you'll get races looking
>> at them.  And probably not the output you want if someone in your
>> container changes the kernel version to trick applications.
>>     
>
> So, do we now go and rip out all usages of utsname()->release and put
> back the #define just because of the loonacy of containers?
>
> No kernel should have to change it's version number to trick an
> application, why would an application care about the version number to
>   
The version number (of the OS not just of the SMB/CIFS implementation, 
both of which are exchanged by client and server) has sometimes been 
useful in debugging problems that I and others and the Samba team look 
at (you can see it in wireshark/tcpdump traces, and it can be logged 
easily on either end as well).

If containers are crazy enough to change the version number, not just 
the hostname, why don't we simply define a three line macro for 
retrieving this which is safe and put it in utsname.h?
