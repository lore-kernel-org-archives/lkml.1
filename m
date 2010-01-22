Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688Ab0AVUJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0AVUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578Ab0AVUJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:09:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0AVUJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:09:45 -0500
Message-ID: <4B5A05A1.3040901@zytor.com>
Date: Fri, 22 Jan 2010 12:08:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 24/38] move round_up/down to kernel.h
References: <1264152287-13866-1-git-send-email-yinghai@kernel.org>	 <1264152287-13866-25-git-send-email-yinghai@kernel.org>	 <alpine.DEB.2.00.1001220851210.2704@router.home> <1264188512.32383.118.camel@Joe-Laptop.home>
In-Reply-To: <1264188512.32383.118.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 11:28 AM, Joe Perches wrote:
> On Fri, 2010-01-22 at 08:52 -0600, Christoph Lameter wrote:
>> On Fri, 22 Jan 2010, Yinghai Lu wrote:
>>> +#define __round_mask(x,y) ((__typeof__(x))((y)-1))
>>> +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
>>> +#define round_down(x,y) ((x) & ~__round_mask(x,y))
>> s/round/round_power2/
> 
> s/round/round_power_of_2/
> BUILD_BUG_ON_NOT_POWER_OF_2
> 

Uh... the whole reason why the classical rounding functions don't work
is that we're using it with non-constants, and therefore the compiler
doesn't know that we're restricted to powers of two (and therefore it
will generate divides.)

	-hpa
