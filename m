Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYHUNSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYHUNSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYHUNSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:18:31 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37326 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYHUNSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:18:30 -0400
Message-Id: <48AD8786.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 21 Aug 2008 14:19:34 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <robert.richter@amd.com>, <linux-kernel@vger.kernel.org>
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU
	hotplug
References: <48AD7F80.76E4.0078.0@novell.com>
 <20080821130259.GA22887@elte.hu>
In-Reply-To: <20080821130259.GA22887@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 21.08.08 15:02 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Converting __cpuinit functions called out of init_amd() (and similar 
>> others) to __init (and making them subject of xxx_initcall() handling 
>> isn't valid, as they would no longer be called for hot plugged CPUs.
>> 
>> Further, since it's likely that in virtualized environments the MSR 
>> write would at best be ignored, I'd also recommend using the 
>> fault-safe accessors here *and* check that the bit actually got set 
>> before setting PCI_HAS_IO_ECS (one would obviously have to BUG() when 
>> hot-plugged CPUs fail to set the bit when those available at boot 
>> successfully did so).
>
>hm, which patch is this exactly, and in what tree? It's not upstream nor 
>in -tip.

It is upstream:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3a27dd1ce5de08e21e0266ddf00e6f1f843bfe8b
(and I just verified it didn't change between -rc3 and -rc4).

Jan

