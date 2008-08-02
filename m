Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYHBBiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYHBBiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 21:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHBBiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 21:38:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYHBBiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 21:38:12 -0400
Message-ID: <4893BA34.20609@zytor.com>
Date: Fri, 01 Aug 2008 18:36:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	 <m1iqukwjjg.fsf@frodo.ebiederm.org>	 <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	 <m1wsj0nyx6.fsf@frodo.ebiederm.org> <86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
In-Reply-To: <86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> Sorry I was referring to the MSI-X source vector number which is a 12
>> bit index into an array of MSI-X vectors on the pci device, not the
>> vector we receive the irq at on the pci card.
> 
> cpu is going to check that vectors in addition to vectors in IDT?

No, but the mapping from MSI-X vectors to -> {CPU, IDT} is arbitrary, as 
the MSI(-X) address and data registers contain the target CPU and 
destination vector, respectively.  However, we may have to manage the 
mappings directly, to re-use IDT entries and provide interrupt balancing.

	-hpa
