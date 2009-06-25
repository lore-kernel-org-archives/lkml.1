Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZFYGay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZFYGay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFYGal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:30:41 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64067 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFYGak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hh0TGAZh9GijhtcQjdmG0WOPALbJ6B8nPyOs6erYlrPwNwDFH732eeMtuUp9AFzljH
         mHHyqQoUx5n5k8zi5awxtJ39MYz0FusROFZ92xwx2NjjoQl/910k/cBCThvrBGJfA+m+
         AUPTbvAVf9W3WAR8tCPbidod9YWbrmThpu1YU=
MIME-Version: 1.0
In-Reply-To: <20090624175943.GB6618@elf.ucw.cz>
References: <4a4254e2.09c5660a.109d.46f8@mx.google.com>
	 <4A425907.2060105@gmail.com> <4A42649D.6080509@gmail.com>
	 <20090624175943.GB6618@elf.ucw.cz>
Date: Thu, 25 Jun 2009 08:30:41 +0200
Message-ID: <2ea1731b0906242330t5f379322sdff9880788e9b181@mail.gmail.com>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: tim.bird@am.sony.com, jamie@shareable.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/24 Pavel Machek <pavel@ucw.cz>:
> On Wed 2009-06-24 19:38:37, Marco wrote:
>> >>> Pavel Machek wrote:
>> >>>> On Mon 2009-06-22 14:50:01, Tim Bird wrote:
>> >>>>> Pavel Machek wrote:
>> >>>>>>> block of fast non-volatile RAM that need to access data on it using a
>> >>>>>>> standard filesytem interface."
>> >>>>>> Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
>> >>>>>> better with ext2.
>> >>>>> Not if you want the RAM-based filesystem to persist over a kernel
>> >>>>> invocation.
>> >>>> Yes, you'll need to code Persistent, RAM-based _block_device_.
>> >>> First of all I have to say that I'd like to update the site and make it
>> >>> clearer but at the moment it's not possible because I'm not the admin
>> >>> and I've already asked to the sourceforge support to have this possibility.
>> >>>
>> >>> About the comments: sincerely I don't understand the comments. We have
>> >>> *already* a fs that takes care to remap a piace of ram (ram, sram,
>> >>> nvram, etc.), takes care of caching problems, takes care of write
>> >> Well, it looks pramfs design is confused. 13MB/sec shows that caching
>> >> _is_ useful for pramfs. So...?
>> >
>> > caching problems means to avoid filesystem corruption, so dirty pages in
>> > the page cache are not allowed to be written back to the backing-store
>> > RAM. It's clear that there is a performance penalty. This penalty should
>> > be reduced by the access speed of the RAM, however the performance are
>> > not important for this special fs as Tim Bird said, so this question is
>> > not relevant for me. If this issue is not clear enough on the web site,
>> > I hope I can update the information in the future.
>> >
>> >>> You are talked about journaling. This schema works well for a disk, but
>> >>> what about a piece of ram? What about a crazy kernel that write in that
>> >>> area for a bug? Do you remember for example the e1000e bug? It's not
>> >> I believe you need both journaling *and* write protection. How do you
>> >> handle power fault while writing data?
>> >>                                                            Pavel
>> >
>> > Ah now the write protection is a "needed feature", in your previous
>> > comment you talked about why not use ext2/3.......
>> >
>> > Marco
>> >
>>
>> Just for your information I tried the same test with pc in a virtual machine with 32MB of RAM:
>>
>> Version 1.03e       ------Sequential Output------ --Sequential Input- --Random-
>>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
>> Machine   Size:chnk K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>> hostname     15M:1k 14156  99 128779 100 92240 100 11669 100 166242  99 80058  82
>>                     ------Sequential Create------ --------Random Create--------
>>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>>                   4  2842  99 133506 104 45088 101  2787  99 79581 101 58212 102
>>
>> These data are the proof of the importance of the environment, workload and so on when we talk
>> about benchmark. Your consideration are really superficial.
>
> Unfortunately, your numbers are meaningless.

I don't think so.

>                                                                        Pavel
>
> (PCs should have cca 3GB/sec RAM transfer rates; and you demosstrated
> cca 166MB/sec read rate; disk is 80MB/sec, so that's too slow. If you
> want to prove your filesystem the filesystem is reasonably fast,
> compare it with ext2 on ramdisk.)
>
This is the point. I don't want compare it with ext2 from performance
point of view. This comparison makes no sense for me. I've done this
test to prove that if you change environment you can change in a
purposeful way the results.

Marco
