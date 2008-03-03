Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYCCSDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYCCSDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYCCSDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:03:01 -0500
Received: from gw.goop.org ([64.81.55.164]:38916 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbYCCSDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:03:00 -0500
Message-ID: <47CC3C2B.6000807@goop.org>
Date: Mon, 03 Mar 2008 09:58:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA	support
 - alternatives"
References: <47C86D7A.5030608@goop.org> <47C8717F.3030009@zytor.com> <47C87488.9030205@goop.org> <20080303173057.GA14598@Krystal>
In-Reply-To: <20080303173057.GA14598@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> I think kmap_atomic is only implemented on x86_32 and only deals with
> highmem pages. It will simply return the original page address without
> changing the protection for other pages, which is not what we want.
> Would ioremap() be a good alternative ?
>   

Perhaps, though that's uncached by default.  You could reserve a fixmap 
slot and use set_fixmap to create the mapping.  Or use vmap, which may 
make dealing with instructions crossing page boundaries a little easier.

    J
