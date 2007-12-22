Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXLVCW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXLVCW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXLVCWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:22:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXLVCWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:22:49 -0500
Message-ID: <476C74F1.2070407@zytor.com>
Date: Fri, 21 Dec 2007 18:22:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: devzero@web.de, linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
References: <49015158@web.de> <47656B9E.3040405@zytor.com> <p73sl1vedhw.fsf@bingen.suse.de> <476C6D06.2070301@zytor.com> <20071222015758.GC4477@one.firstfloor.org>
In-Reply-To: <20071222015758.GC4477@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Those don't live in an area of memory which is hard-limited to 32K.
> 
> Why not 64k?
> 

Because the bootloader needs some memory in the same segment that it 
controls.  Furthermore, since there were some residual uses of the 
0x9000 segment (now removed, but not all bootloaders could be easily 
fixed), we were limited to about 40K for everything.

Unfortunately we already have the problem that some bootloaders (notably 
LOADLIN and mknbi) hardcoded an arbitrary limit which was even smaller 
than that (about 16K, which we're already pushing up against.)

> Ok, that's a different argument than before. Ok. Although it's
> only a few bytes. 
> 
> I would lobby for any message at least contain the suggestion to try
> edd=off. That could save users a lot of time.

The important thing is that there is a message before and after.  The 
rest can be dealt with by Google on in documentation.  That's what the 
patch currently in x86setup.git does.

	-hpa
