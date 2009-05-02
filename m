Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZEBAAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZEBAAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZEBAAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:00:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:45210 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752703AbZEBAAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:00:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,281,1239001200"; 
   d="scan'208";a="686813963"
Message-ID: <49FB8D27.3000305@linux.intel.com>
Date: Fri, 01 May 2009 17:00:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andreas Schwab <schwab@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: "N" symbols and System.map
References: <49FB7692.2000508@linux.intel.com> <m2preso1wl.fsf@igel.home> <20090501232149.GA28888@uranus.ravnborg.org>
In-Reply-To: <20090501232149.GA28888@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, May 02, 2009 at 01:10:18AM +0200, Andreas Schwab wrote:
>> "H. Peter Anvin" <hpa@linux.intel.com> writes:
>>
>>> right now, we filter out symbols that nm tag N, meaning "debugging
>>> symbols", from System.map.  However, at least on x86, the linker-generated
>>> symbol _end is tagged N, and in fact is the only N in the entire image.
>>>
>>> Are there other architectures which would suffer if N were included in
>>> System.map, or would that be a reasonable thing to do?
>> There should not be any N symbols unless you are using stabs debugging.
> 
> We have in vmlinux:
>         .end : AT(ADDR(.end) - LOAD_OFFSET) {
>                 _end = .;
>         }
> 
> 
> And I see:
> c1834000 N _end
> 
> This is the _only_ 'N' symbol in my vmlinux.
> 

Yup, this is what happens.  I don't know why the linker does this, and 
if there is a way around it.

	-hpa

