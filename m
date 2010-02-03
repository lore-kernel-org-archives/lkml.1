Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab0BCKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:25:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab0BCKZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:25:25 -0500
Message-ID: <4B694DEF.70301@kernel.org>
Date: Wed, 03 Feb 2010 02:20:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Brandon Philips <bphilips@suse.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       YinghaiLu@suse.de, Suresh Siddha <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: x86: fix race in create_irq_nr on irq_desc
References: <20100203033109.GA17985@jenkins.home.ifup.org>
In-Reply-To: <20100203033109.GA17985@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2010 07:31 PM, Brandon Philips wrote:
> Race in create_irq_nr():
> 
> - Thread 1 loops through and calls irq_to_desc_alloc_node with new=0x66.
> 
> - Thread 2 has exited the loop with irq=0x66 and calls dynamic_irq_init(0x66)
>   setting desc->chip_data = NULL
> 
> - Thread 1 then dereferences NULL via desc_new->chip_data->vector

two threads get same irq?

YH
