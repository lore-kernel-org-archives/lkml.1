Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZAQXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZAQXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761242AbZAQXZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:25:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761082AbZAQXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:25:13 -0500
Message-ID: <497268B7.40301@zytor.com>
Date: Sat, 17 Jan 2009 15:24:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com> <20090109224804.GD6472@linux-os.sc.intel.com> <20090117174224.GA1409@ucw.cz>
In-Reply-To: <20090117174224.GA1409@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2009-01-09 14:48:04, Suresh Siddha wrote:
>> On Fri, Jan 09, 2009 at 02:39:31PM -0800, H. Peter Anvin wrote:
>>> Suresh Siddha wrote:
>>>> Here X is trying to map first 8KB of memory using /dev/mem. Existing
>>>> code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
>>>> code changes don't allow to map memory with different attributes
>>>> at the same time.
>>>>
>>> Why was 0-4 KB marked as non-RAM?  It is most definitely RAM, and should
>>> be WB.
>> While in reality it is RAM, we have CONFIG_STRICT_DEVMEM which doesn't allow
>> apps to map RAM pages using /dev/mem. And to allow app's to map the
>> legacy 0-4KB bios data page, we consider it as non-RAM.
> 
> Fix config_strict_devmem? Ram is ram, and we should not li for
> strict_devmem benefit...
> 

*As far as I understand* this is only considered non-RAM for the purpose
of strict_devmem?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

