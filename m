Return-Path: <linux-kernel-owner+w=401wt.eu-S1751430AbXBOBA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbXBOBA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXBOBA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:00:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62834 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbXBOBA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:00:57 -0500
Message-ID: <45D3B08D.6040602@oracle.com>
Date: Wed, 14 Feb 2007 16:59:57 -0800
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: clem@clem.clem-digital.net, linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
References: <200702130110.l1D1ADai012897@clem.clem-digital.net> <20070212.202054.104031463.davem@davemloft.net>
In-Reply-To: <20070212.202054.104031463.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------000909080608060802030408"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000909080608060802030408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Pete Clements <clem@clem.clem-digital.net>
> Date: Mon, 12 Feb 2007 20:10:13 -0500 (EST)
> 
>> 2.6.20-git8 fails compile:
>>
>>   CHK     include/linux/compile.h
>>   UPD     include/linux/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> net/built-in.o: In function `svc_udp_recvfrom':
>> svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
>> make: *** [.tmp_vmlinux1] Error 1
> 
> Chuck, you will need to somehow make CONFIG_SUNRPC "depend" upon IPV6
> so that if IPV6 is modular SUNRPC can only be built modular.
> 
> Otherwise the symbols won't resolve correctly.
> 
> Everybody hits this problem when they add ipv6 support to
> something. :-)
> 

Interestingly, doing a build with ALLYESCONFIG, ALLMODCONFIG, and 
ALLNOCONFIG doesn't catch this type of error.

I just did a copy+paste and that brought in ipv6_addr_type.  So I'm not 
convinced it's really needed here.  David, can you take a look at the 
code in svcsock.c right around the ipv6_addr_type() call and let me know 
if we can avoid that call outright?

--------------000909080608060802030408
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture Linux Projects Group
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------000909080608060802030408--
