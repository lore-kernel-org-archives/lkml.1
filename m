Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYHACXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYHACXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 22:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHACXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 22:23:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6055 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYHACXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 22:23:12 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5351"; a="5060069"
Message-ID: <4892738D.5040703@qualcomm.com>
Date: Thu, 31 Jul 2008 19:23:09 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Oruba <peter.oruba@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com> <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com> <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com> <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com> <b647ffbd0807300334q57cdca6fu474cc7b6bed36102@mail.gmail.com> <48909854.2040201@qualcomm.com> <b647ffbd0807301138i5f721a39p9b20e4e918aa07b7@mail.gmail.com> <20080731212441.GF2729@elte.hu>
In-Reply-To: <20080731212441.GF2729@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> 
>> I've even suggested to consider doing microcode update somewhere 
>> earlier in start_secondary() (say, right before cpu_idle()). So it'd 
>> be done as ealry as possible + we don't mess up with cpu-hotplug 
>> events.
> 
> i have no problems with that approach in principle. Microcode updates 
> are special and black magic things anyway.
> 

I still think we should just do the update via schedule_work_on() and be 
done with it. Maybe in theory it should be done as early as possible but 
in practice hotplug handler -> workqueue will be soon enough, I think.

Max
