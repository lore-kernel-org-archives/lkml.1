Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYAaLTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYAaLTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:19:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764442AbYAaLSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:18:52 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46600 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764358AbYAaLSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:18:51 -0500
Date: Thu, 31 Jan 2008 12:18:50 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Steve French <smfrench@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove smbfs
In-Reply-To: <524f69650801301723w2f186f73h2cb30a6a30793def@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801311215280.4864@fbirervta.pbzchgretzou.qr>
References: <20080128220835.GF8767@does.not.exist> 
 <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr> 
 <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com> 
 <Pine.LNX.4.64.0801302003560.13036@fbirervta.pbzchgretzou.qr>
 <524f69650801301723w2f186f73h2cb30a6a30793def@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 19:23, Steve French wrote:
>> On Jan 30 2008 12:53, Steve French wrote:
>> >I have mounted to Windows98 a few months ago with no problems (other
>> >than a few restrictions like you can't set the file times via utimes).
>> > For mounts to Windows98 note that you have to specify the server
>> >netbios name on the mount (since it is not the same as the DNS name).
>> >In your example your would need to specify "servernetbiosname=WIN98"
>> >in the mount options (until mount.cifs autoretries with
>> >servernetbiosname assumed to be the beginning of the UNC name - note
>> >that later servers have a dummy netbios name that is used so this
>> >mount option is only needed for OS/2 and Win9x).
>>
>> Ok that works. I had tried "netbiosname" but not "servernetbiosname"
>> (only fuzzy memories from the last win98 encounter and the suggestion
>> to use netbiossomething).
>>
>> I think servernetbiosname should implicitly be assumed to be the
>> same as the //hostpart/ when it's not explicitly specified, no?
>
>Unfortunately, it is not quite that easy since there is a default
>"dummy" netbiosname that you are supposed to specify.
>[...]
>There is retry which can be tried.  When the server does not listen on
>port 445 and mount fails to *SMBSERVER on port 139 (and retry using
>the uppercased tcp name as the netbios name fails) - we can try to do
>an "adapter status" rfc1001 call to the ip address of the target and
>pick the first netbiosname (or at least the first one that ends with
>the server suffix - ie a byte of 0x20 for byte 16 of the netbios
>name).   This complicates the mount.cifs helpers retry logic and
>adding rfc1001 adapter status code into the kernel also would be a few
>hundred lines of kernel code for little benefit if any for current
>servers, but it could be done.   Simply adding the one retry (for
>failed mounts using servernetbiosname=<target-host-name> would
>probably take care of most cases.
>
Yes, that is what I'd like, the simple retry with the servernetbiosname
taken from //foo/. Querying adapter and all that seems unnecessary since
if I say //foo/, I really mean servernetbiosname=foo,ip=<resolve foo>
not servernetbiosname=bar,ip=<resolve foo>.
