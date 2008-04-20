Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYDTOK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYDTOK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYDTOKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:10:03 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:33510 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbYDTOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:10:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=PvxLnl+6hVBRNMjO3KhhYN7D4RsPgwKDOzeJkMbb43FdxYtExpGy42jJkgb7pS8wsH72NaOTwDH+0cbJ2pSirT79pQRydQNI1/efI0Qy0KGwzieBoElRBs4PD1syhMacub5uZTed0z3osofsTvj0ISc+vG2zYvOZwcF/vcHwdnQ=;
Message-ID: <480B4E87.4020709@unsolicited.net>
Date: Sun, 20 Apr 2008 15:09:11 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <480A3D62.9000401@unsolicited.net> <1208676743.4763.10.camel@marge.simson.net>
In-Reply-To: <1208676743.4763.10.camel@marge.simson.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2008-04-19 at 19:43 +0100, David wrote:
>   
>> I'm wondering if anyone might be able to help with a capability problem 
>> I've noticed with .25 My ntp daemon will no longer run as any non-root 
>> user, and after some investigation it seems that calls to prctl() are 
>> failing.
>>
>> CONFIG_SECURITY_CAPABILITIES=y , so this should work?
>>
>> System is 32 bit x86 based on a venerable SuSE 9.1 distro.
>>
>> Full .config is attached.
>>
>> Thanks
>> David
>>
>>
>>     
>
> FWIW, ntpd runs just fine here as user ntp on both my P4 and Q6600 boxen
> with opensuse 10.3.
>
> marge:..tmp/linux-2.6.25 # grep SECUR .config
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4DEV_FS_SECURITY=y
> CONFIG_SECURITY=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_CAPABILITIES=y
> CONFIG_SECURITY_FILE_CAPABILITIES=y
> CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
> # CONFIG_SECURITY_SELINUX is not set
> marge:..tmp/linux-2.6.25 # grep SECUR /xx
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_REISERFS_FS_SECURITY=y
> # CONFIG_XFS_SECURITY is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITY_NETWORK=y
> # CONFIG_SECURITY_NETWORK_XFRM is not set
> CONFIG_SECURITY_CAPABILITIES=y
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> # CONFIG_SECURITY_ROOTPLUG is not set
> CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
>
> I notice I have CONFIG_SECURITY_FILE_CAPABILITIES set, and you don't.  I
> have not even the foggiest clue whether that has anything to do with the
> price of tea in china though :)
>   
I've just set

CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_NETWORK_XFRM=y

to no avail.. I still get


20 Apr 15:04:20 ntpd[15694]: cap_set_proc() failed to drop root 
privileges: Invalid argument

after rebuild & reboot. No massive deal, I'll just run ntpd as root for 
now, but there's definitely something funny going on.

Cheers
David

