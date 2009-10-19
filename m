Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZJSCkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZJSCkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 22:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZJSCkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 22:40:47 -0400
Received: from claw.goop.org ([74.207.240.146]:41590 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZJSCkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 22:40:46 -0400
Message-ID: <4ADBCCFA.1020507@goop.org>
Date: Mon, 19 Oct 2009 11:20:42 +0900
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Earl Chew <earl_chew@agilent.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Using remap_pfn_range() to increase total_vm beyond RLIMIT_AS
References: <4AD7916A.2080200@agilent.com>
In-Reply-To: <4AD7916A.2080200@agilent.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/09 06:17, Earl Chew wrote:
> remap_pfn_range() is defined in mm/memory.c and as far as I
> can tell, does _not_ cause total_vm or reserved_vm to be updated.
>
> Is this right?
>
>
> RLIMIT_AS is only checked against total_vm in mm/mmap.c in the function
> may_expand_vm().
>
> I think this means that a device driver can map pages into
> a process and thus effectively increase address space of
> a process above and beyond the limit set by RLIMIT_AS.

I suspect this is justified because remap_pfn_range is generally
(always?) used to map device memory, and other memory which isn't
represented by struct pages, so it doesn't really count as real memory
usage.

    J
