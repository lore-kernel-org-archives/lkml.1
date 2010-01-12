Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642Ab0ALWwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0ALWwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990Ab0ALWwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:52:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0ALWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:52:07 -0500
Message-ID: <4B4CFCD2.6000000@zytor.com>
Date: Tue, 12 Jan 2010 14:50:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] x86: using logical flat for amd cpu too.
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-2-git-send-email-yinghai@kernel.org> <20100112082706.GE28425@in.ibm.com>
In-Reply-To: <20100112082706.GE28425@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 12:27 AM, Ananth N Mavinakayanahalli wrote:
> On Mon, Jan 11, 2010 at 06:48:01PM -0800, Yinghai Lu wrote:
> 
>> not sure it works again, could be bios fix the irq routing dest ?
> 
> Nope, it doesn't. I applied this patchset.. no luck.

Okay, I have been monitoring this discussion, but I would like to make
sure I have understood all the relevant details:

1. The original patch is already reverted in Linus' tree.

2. The Intel/AMD thing is likely to be a red herring; specifically it's
   a proxy for some other platform difference.

3. There is at least one platform ("an IBM platform with two quad-core
   Xeon X7350 CPUs" -- which platform?) for which the logical
   destination mode fails even though it should have been supported.
   Currently there is no known workaround for this platform other than
   forcing physical mode on this machine, which is what the current
   code does, for valid or invalid reasons.

It would be good to clean up this code for .34, and I would really like
to know *which* platform this is; furthermore, Ananth, if you could send
as much technical information on this platform as possible including DMI
and lspci dumps I would appreciate it.

Furthermore, is this a production or preproduction system?

	-hpa
