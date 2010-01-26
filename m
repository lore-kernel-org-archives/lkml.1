Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565Ab0AZCQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0AZCQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416Ab0AZCQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:16:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0AZCQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:16:25 -0500
Message-ID: <4B5E501A.4000707@kernel.org>
Date: Mon, 25 Jan 2010 18:14:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH -v5 0/38] x86: not use  bootmem for x86
References: <1264152287-13866-1-git-send-email-yinghai@kernel.org> <4B5E3A12.4030506@zytor.com>
In-Reply-To: <4B5E3A12.4030506@zytor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 04:40 PM, H. Peter Anvin wrote:
> I have been looking at this patchset and tried it out; it has a build
> failure because of a naming conflict:
> 
> /home/hpa/kernel/linux-2.6-tip.range/drivers/pci/hotplug/ibmphp_res.c:43: error:
> conflicting types for ‘add_range’
> /home/hpa/kernel/linux-2.6-tip.range/include/linux/range.h:9: note:
> previous declaration of ‘add_range’ was here
> 
> "add_range" is static.
> 
> This makes me concerned that the naming is too generic.  In particular,
> we tend to prefer naming of the type subsystem_function(), so in this
> case range_add() might be a more suitable naming scheme.

ibmphp_res.c:static int add_range (int type, struct range_node *, struct bus_node *);
ibmphp_res.c:           add_range (flag, newrange, newbus);
ibmphp_res.c:static int add_range (int type, struct range_node *range, struct bus_node *bus_cur)
ibmphp_res.c: * the range numbers that they correspond to.  It was called from add_range fnc
ibmphp_res.c:                                                                   add_range (IO, range, bus_sec);
ibmphp_res.c:                                                                   add_range (MEM, range, bus_sec);
ibmphp_res.c:                                                                   add_range (PFMEM, range, bus_sec);

can we change name in ibmphp_res.c instead. that is local one.

> 
> I'm going to spend more time on this patchset.
> 
Thanks

Yinghai
