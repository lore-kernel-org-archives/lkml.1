Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYFCPYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYFCPYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYFCPX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:23:56 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43214 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYFCPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:23:55 -0400
Message-ID: <48456225.6070505@bull.net>
Date: Tue, 03 Jun 2008 17:24:21 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 09/10] netns: Enable tagging for net_class directories
 in sysfs
References: <20080602134438.224352910@theryb.frec.bull.fr> <20080602134439.782528644@theryb.frec.bull.fr> <20080603040818.GA18507@suse.de>
In-Reply-To: <20080603040818.GA18507@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jun 02, 2008 at 03:46:08PM +0200, Benjamin Thery wrote:
>> net: Enable tagging for net_class directories in sysfs
>>
>> The problem.  Network devices show up in sysfs and with the network
>> namespace active multiple devices with the same name can show up in
>> the same directory, ouch!
>>
>> To avoid that problem and allow existing applications in network namespaces
>> to see the same interface that is currently presented in sysfs, this
>> patch enables the tagging directory support in sysfs.
>>
>> By using the network namespace pointers as tags to separate out the
>> the sysfs directory entries we ensure that we don't have conflicts
>> in the directories and applications only see a limited set of
>> the network devices.
> 
> I don't like it how the network subsystem is starting to leach into the
> sysfs core here.  What happens when the next subsystem wants to do the
> same thing?  And then the next one?  Will they all have to do this kind
> of intrusive changes to sysfs?
 >
 > Can't this be done only in the network subsystem?

I'm not sure to understand exactly what you mean.

What you don't like is seeing these hunks of network code in
fs/sysfs/mount.c? And you prefer to see these bits of code resides in
the network subsystem instead and see only "generic" sysfs services in
fs/sysfs/mount.c?

If this is it, I have some idea to implement a less intrusive
sysfs_net_exit(), which can be shared with the other namespaces.
Serge introduces the same kind of changes in patch 10 to fix an issue in 
  user namespace. I think we can share a bit of code and move the parts
specific to each namespace in their own subsystems.

Benjamin

> 
> thanks,
> 
> greg k-h
> 
> 


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
