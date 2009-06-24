Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbZFXRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbZFXRmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZFXRmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:42:43 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60298 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFXRmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GizCsGGMofRvdShu47TExVZjfii06eqxRLYAPew2BOubnN7T3aYiCZEcbssRvmYx8y
         7G8fS5CWJ78tRjzpxtIn8sre3NE0e4zFk00xcWj0OZiQYzI7TRH3bGV5e1/A14zhc++6
         WibqWcVI6DdKVcY4u47KATci53+fhv5kmi+n0=
Message-ID: <4A42649D.6080509@gmail.com>
Date: Wed, 24 Jun 2009 19:38:37 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: pavel@ucw.cz
CC: tim.bird@am.sony.com, jamie@shareable.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4a4254e2.09c5660a.109d.46f8@mx.google.com> <4A425907.2060105@gmail.com>
In-Reply-To: <4A425907.2060105@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Pavel Machek wrote:
>>>> On Mon 2009-06-22 14:50:01, Tim Bird wrote:
>>>>> Pavel Machek wrote:
>>>>>>> block of fast non-volatile RAM that need to access data on it using a
>>>>>>> standard filesytem interface."
>>>>>> Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
>>>>>> better with ext2.
>>>>> Not if you want the RAM-based filesystem to persist over a kernel
>>>>> invocation.
>>>> Yes, you'll need to code Persistent, RAM-based _block_device_. 
>>> First of all I have to say that I'd like to update the site and make it
>>> clearer but at the moment it's not possible because I'm not the admin
>>> and I've already asked to the sourceforge support to have this possibility.
>>>
>>> About the comments: sincerely I don't understand the comments. We have
>>> *already* a fs that takes care to remap a piace of ram (ram, sram,
>>> nvram, etc.), takes care of caching problems, takes care of write
>> Well, it looks pramfs design is confused. 13MB/sec shows that caching
>> _is_ useful for pramfs. So...?
> 
> caching problems means to avoid filesystem corruption, so dirty pages in
> the page cache are not allowed to be written back to the backing-store
> RAM. It's clear that there is a performance penalty. This penalty should
> be reduced by the access speed of the RAM, however the performance are
> not important for this special fs as Tim Bird said, so this question is
> not relevant for me. If this issue is not clear enough on the web site,
> I hope I can update the information in the future.
> 
>>> You are talked about journaling. This schema works well for a disk, but
>>> what about a piece of ram? What about a crazy kernel that write in that
>>> area for a bug? Do you remember for example the e1000e bug? It's not
>> I believe you need both journaling *and* write protection. How do you
>> handle power fault while writing data?
>> 								Pavel
> 
> Ah now the write protection is a "needed feature", in your previous
> comment you talked about why not use ext2/3.......
> 
> Marco
> 

Just for your information I tried the same test with pc in a virtual machine with 32MB of RAM:

Version 1.03e       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine   Size:chnk K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
hostname     15M:1k 14156  99 128779 100 92240 100 11669 100 166242  99 80058  82
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                  4  2842  99 133506 104 45088 101  2787  99 79581 101 58212 102

These data are the proof of the importance of the environment, workload and so on when we talk 
about benchmark. Your consideration are really superficial.

Marco
