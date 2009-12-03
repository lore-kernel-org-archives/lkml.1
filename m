Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZLCATV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZLCATV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZLCATV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:19:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbZLCATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:19:20 -0500
Message-ID: <4B170204.4080604@zytor.com>
Date: Wed, 02 Dec 2009 16:10:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] pps: low level IRQ timestamps recording.
References: <1259774329-29663-1-git-send-email-giometti@linux.it> <1259774329-29663-2-git-send-email-giometti@linux.it> <1259774329-29663-3-git-send-email-giometti@linux.it> <1259774329-29663-4-git-send-email-giometti@linux.it> <1259774329-29663-5-git-send-email-giometti@linux.it> <1259774329-29663-6-git-send-email-giometti@linux.it> <1259774329-29663-7-git-send-email-giometti@linux.it> <1259774329-29663-8-git-send-email-giometti@linux.it> <1259774329-29663-9-git-send-email-giometti@linux.it> <1259774329-29663-10-git-send-email-giometti@linux.it>
In-Reply-To: <1259774329-29663-10-git-send-email-giometti@linux.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 09:18 AM, Rodolfo Giometti wrote:
> Add low level IRQ timestamps recording for x86 (32 and 64 bits)
> platforms and enable UART clients in order to use it.
> 
> This improves PPS precision. :)

It also invokes getnstimeofday on every single interrupt, including ones
which have absolutely nothing to do with the PPS, and are potentially
high volume.  getnstimeofday can be a fairly expensive operation,
especially if the best available clock is away from the CPU, or it
requires extensive arithmetic in order to normalize the clock value...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

