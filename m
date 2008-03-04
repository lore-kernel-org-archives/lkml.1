Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbYCDVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbYCDVdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbYCDVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:33:09 -0500
Received: from gw.goop.org ([64.81.55.164]:48035 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbYCDVdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:33:08 -0500
Message-ID: <47CDBEDC.1050302@goop.org>
Date: Tue, 04 Mar 2008 13:27:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu>
In-Reply-To: <20080304212821.GB8944@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> I think set_pmd_pfn, which is only called by __set_fixmap, might have 
>> a preempt bug in it.
>>     
>
> yes, and we had similar preemption bugs in the past. I guess most places 
> are either infrequent or have some natural atomicity anyway. Wanna send 
> a patch?
>   

Sure.  Should it just disable preemption, or take a lock?  It calls 
set_pte_at without holding any pte locks; that seems to be relatively 
common.  Is it OK when you're operating on init_mm?

    J
