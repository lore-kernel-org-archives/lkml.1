Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYFLWkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYFLWkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYFLWjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:39:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbYFLWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:39:52 -0400
Message-ID: <4851A595.8070601@zytor.com>
Date: Thu, 12 Jun 2008 15:39:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: yhlu.kernel@gmail.com, andi@firstfloor.org, mingo@elte.hu, bwalle@suse.de,
       hannes@saeurebad.de, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ...
 on x86_64
References: <20080612050609.88a8cf7f.pj@sgi.com>	<86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>	<20080612111943.c140c4cb.pj@sgi.com>	<86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>	<20080612151032.5a59309b.pj@sgi.com>	<86802c440806121329s54bb1e6dobaaa15c26e7dc81c@mail.gmail.com>	<48519077.2050402@zytor.com> <20080612165252.b7ce6902.pj@sgi.com>
In-Reply-To: <20080612165252.b7ce6902.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> 
> Reserving EBDA with EFI is fine by what little I know.
> 
> But the current code doesn't like it -- if the EFI memmap range is inside
> the EBDA range, then the reserve_early() routine panics with:
> 
>     "Overlapping early reservations"
> 
> Something needs tweaking here somehow ... and I'm not the one to know what.
> 

Right of course... in this particular case, one of the reservations is 
conservative "just in case" and the other is normative, but the code 
doesn't deal with that since it's potentially flagging a bug.

	-hpa
