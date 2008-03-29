Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbYC2K5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbYC2K5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 06:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYC2K5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 06:57:05 -0400
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:56012 "EHLO
	spaceymail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbYC2K5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 06:57:04 -0400
Message-ID: <47EE2072.7000504@froyn.name>
Date: Sat, 29 Mar 2008 11:56:50 +0100
From: Ketil Froyn <ketil@froyn.name>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unexpected rename() behaviour
References: <47ED8858.9000401@froyn.name> <20080329011656.7c38265a@werewolf>
In-Reply-To: <20080329011656.7c38265a@werewolf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón skrev:
> On Sat, 29 Mar 2008 01:07:52 +0100, Ketil Froyn <ketil@froyn.name> wrote:
> 
>> Hi,
>>
>> The following behaviour was unexpected (tested on Debian/ext3):
>>
>> $ echo 1 > 1
>> $ ln 1 2
>> $ cat 2
>> 1
>> $ ./rename 2 1
>> $ echo $?
>> 0
>> $ cat 2
>> 1
>>
>> The code for ./rename is simple:
>>
>> ---
>> /* compile: gcc -o rename rename.c */
>> #include <stdio.h>
>> int main(int argc, char *argv[]) { return rename(argv[1], argv[2]); }
>> ---
>>
>> I thought this must be wrong behaviour, but I have been unable to 
>> confirm what the correct result should be in this special case. rename() 
>> returns success, but the source file is intact, which seems odd. The 
>> "mv" command specifically checks for cases like this and calls 
>> unlink("2") instead of rename("2", "1"). Are all applications meant to 
>> do this? What standards describe what rename() should do in cases like this?
>>
> 
> man 2 rename:
> 
>        If  oldpath  and  newpath are existing hard links referring to the same
>        file, then rename() does nothing, and returns a success status.
> 
> That's why mv checks the special case.

This was not in my (Debian 4.0) version of the man page. I assume it is 
listed in the DESCRIPTION section and not the BUGS section.

Is this a corner case undefined by POSIX, for instance, or does POSIX 
explicitly say that this is the correct behaviour? I have verified that 
the same happens on BSD, but I still find it odd that a successful 
rename(oldpath,newpath) should leave oldpath in place.

So given the case that it is a requirement that oldpath should be 
removed after the rename(), does all software need to check whether 
oldpath and newpath are existing hard links referring to the same file, 
and if so, call unlink(oldpath) instead? I would guess that lots of 
existing software doesn't.

Regards,
Ketil Froyn
