Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237Ab0ATVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0ATVDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929Ab0ATVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:03:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:37753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab0ATVDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:03:46 -0500
Message-ID: <4B576F79.9020205@kernel.org>
Date: Wed, 20 Jan 2010 13:02:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-23-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191155540.22304@router.home> <4B57675E.7070309@kernel.org> <alpine.DEB.2.00.1001201451430.17915@router.home>
In-Reply-To: <alpine.DEB.2.00.1001201451430.17915@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 12:52 PM, Christoph Lameter wrote:
> On Wed, 20 Jan 2010, Yinghai Lu wrote:
> 
>> like this, using DIVIDE for all ?
> 
> I liked the __round_mask better

how about if y is not pow_of_two ?

> 
> 
>> -#define __round_mask(x,y) ((__typeof__(x))((y)-1))
>> -#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
>> -#define round_down(x,y) ((x) & ~__round_mask(x,y))
>> +#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>> +#define rounddown(x, y) (((x) / (y)) * (y))
> 
>> +#define round_up(x,y) roundup(x,y)
>> +#define round_down(x,y) rounddown(x,y)
> 
> Why two aliases? Make the use consistent throughout the source.

