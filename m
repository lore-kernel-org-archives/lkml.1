Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZFXXDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZFXXDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZFXXCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:02:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZFXXCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:02:54 -0400
Message-ID: <4A42B093.4070702@zytor.com>
Date: Wed, 24 Jun 2009 16:02:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, ray-lk@madrabbit.org,
       renton@renton.name, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru>	<4A26EB18.6060907@zytor.com>	<20090609161945.811cc01f.akpm@linux-foundation.org>	<2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>	<20090609165304.add1a872.akpm@linux-foundation.org>	<4A301CCD.7070707@zytor.com>	<20090624200108.GR8633@ZenIV.linux.org.uk> <20090624145822.72aaaff6.akpm@linux-foundation.org>
In-Reply-To: <20090624145822.72aaaff6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>>
>>> umounts do not appear affected; each umount still take negible time.
>> I think I know what's going on.  /sbin/mount is linked against libselinux
>> /sbin/umount is not.  And FPOS in question blows if you
>> 	* do not have selinuxfs mounted (e.g. because selinux is not enabled)
>> 	* have a lot of mounts.
>>
>> What happens is that this piece of crap checks for presence of selinuxfs
>> on /selinux; then, if the thing isn't there, we go and scan the entire
>> /proc/mounts in search of selinuxfs mounts.
>>
>> If akpm has selinux enabled on his testbox and you don't have it on yours,
>> we have all observations explained.
> 
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
> CONFIG_SECURITY_SELINUX_DISABLE=y
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> 

Wow.  It doesn't even check for selinux actually being enabled before
embarking on this stupidity.

FAIL.

	-hpa
