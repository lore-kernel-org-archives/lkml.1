Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbXJDTms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbXJDTms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbXJDTmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:42:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbXJDTmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:42:40 -0400
Message-ID: <47054205.8000908@redhat.com>
Date: Thu, 04 Oct 2007 15:41:57 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
 client git tree...
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>	 <20071004085206.0a8e37b5@poseidon.drzeus.cx>	 <1191506450.6685.17.camel@heimdal.trondhjem.org>	 <20071004184304.6e71ab6d@poseidon.drzeus.cx>	 <20071004114243.3161af16.akpm@linux-foundation.org> <1191525363.6739.12.camel@heimdal.trondhjem.org>
In-Reply-To: <1191525363.6739.12.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Thu, 2007-10-04 at 11:42 -0700, Andrew Morton wrote:
>   
>> On Thu, 4 Oct 2007 18:43:04 +0200
>> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>>
>>     
>>> On Thu, 04 Oct 2007 10:00:50 -0400
>>> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
>>>
>>>       
>>>> On Thu, 2007-10-04 at 08:52 +0200, Pierre Ossman wrote:
>>>>         
>>>>> On Wed, 03 Oct 2007 19:41:16 -0400
>>>>> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
>>>>>
>>>>>           
>>>>>> We also have the 64-bit inode support from RedHat/Peter Staubach.
>>>>>>
>>>>>>             
>>>>> As has been pointed[1] out[2], this will cause regressions for
>>>>> non-LFS applications (of which there are still lots and lots). This
>>>>> change should be in feature-removal (the "feature" being removed is
>>>>> legacy support for non-LFS applications using NFS servers that make
>>>>> full use of the protocol) and preferably accompanied with
>>>>> appropriate user space changes (e.g. compatibility option in glibc).
>>>>>
>>>>> [1] https://bugzilla.redhat.com/show_bug.cgi?id=241348
>>>>> [2] http://marc.info/?l=linux-nfs&m=118701088726477&w=2
>>>>>
>>>>> Rgds
>>>>>           
>>>> How about a boot/module parameter to turn it on or off?
>>>>
>>>>         
>>> That would be perfect. It can even be in non-legacy mode by default,
>>> just as long as you can go back to the old behaviour when/if you run
>>> into a non-LFS application.
>>>
>>>       
>> Wouldn't a mount option be better?
>>     
>
> I suppose that might be OK if you know that the 32-bit legacy
> applications will only touch one or two servers, but that sounds like a
> niche thing.
>
> On the downside, forcing all those people who have portable 64-bit aware
> applications to upgrade their version of mount just in order to have
> stat64() work correctly seems unnecessarily complicated. I'd prefer not
> to have to do that unless someone comes up with a good reason why we
> must.

I would agree.  The 64 bit fileids will only become visible when
the server is exporting file systems which contain fileids which
are bigger than 32 bits and then only when the application
encounters these files.

Also, these 32-bit legacy applications are going to have a
problem if they are ever run on a system which contains local
file systems which expose the large fileids.

It would be better to identify these applications and get them
fixed.  The world is evolving and it is time for them to do so.

       ps
