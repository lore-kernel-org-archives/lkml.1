Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0AKX0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0AKX0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452Ab0AKX0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:26:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0AKX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:26:37 -0500
Message-ID: <4B4BB397.5090500@zytor.com>
Date: Mon, 11 Jan 2010 15:26:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <20100111140255.GA1416@ucw.cz> <4B4B5768.2040005@zytor.com> <20100111201734.GA11674@elf.ucw.cz>
In-Reply-To: <20100111201734.GA11674@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 12:17 PM, Pavel Machek wrote:
>>
>> Uhm, that's just plain wrong.
>>
>> It doesn't matter if there is a "special mapping layer" -- if you're
>> crossing multiple erase blocks you're still having more churn in
>> your flash translation layer, with more wear on the device, and
>> lower performance than if you didn't.
> 
> Eraseblocks really should not matter. It is not as if each logical
> sector belongs to one eraseblock....
> 
> (OTOH, maybe the eraseblock *groups* that are basis for wear-leveling
> do, or maybe firmware is doing something really really strange.)
> 								Pavel

Maybe they "should not" matter, but they *do* matter.  In most existing
FTLs, each logical sector *does* belong to one erase block, although
which particular erase block that is of course moves around.  However,
the invariant that matters though -- and the reason alignment matters --
is that for most FTLs, the *offset* of any particular logical sector
within the erase block it currently belongs to is invariant, i.e. the
FTL operates on physical sectors which are the same size as the erase
blocks.

	-hpa
