Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZLXMDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZLXMDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZLXMDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:03:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:56969 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZLXMDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:03:01 -0500
Message-ID: <4B33592B.6000107@kernel.org>
Date: Thu, 24 Dec 2009 21:06:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org>
In-Reply-To: <4B2F40C0.5020407@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/21/2009 06:32 PM, Tim Blechmann wrote:
>>>>> removing module-common.lds from LDFLAGS_MODULE, my machine boots fine
>>>>> and without any error messages:
>>>>
>>>> Looks like some necessary part of module image ends up in discarded
>>>> sections.  Before the commit, the build process kept those sections so
>>>> it worked.  The code has been there for some time now and you're the
>>>> first one to report it, so I suppose your .config is a bit different
>>>> from more usual ones.  Can you please attach it?
>>>
>>> it is not too different ... it is based on the .config file of the
>>> ubuntu kernel with a few tweaks ...
>>> one odd thing is, that i once was able to boot 2.6.32-rcX kernels, at
>>> one point, i kept getting these bug messages ... i didn't (knowingly)
>>> change the configuration, though ...
>>
>> Hmmm... weirdly I can't reproduce the problem here with the same
>> config.  Can you please attach "readelf -a lp.ko" with and without the
>> module-common.lds struck out?
> 
> as i said before, the configuration is not really uncommon ... the
> readelf output is attached.

Hmmm.... I think it's more convoluted than I originally thought.  I
was expecting a missing section but in the broken case the linker has
assigned addresses to sections even though it was a relocatable link.
That's just strange.

Can you please post the output of "ld --version"?  Also, what distro
are you on?

Thanks.

-- 
tejun
