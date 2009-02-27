Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZB0TVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZB0TVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZB0TVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:21:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbZB0TU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:20:59 -0500
Message-ID: <49A83C52.5050801@zytor.com>
Date: Fri, 27 Feb 2009 11:17:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org>
In-Reply-To: <49A829CE.9020509@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> unsigned int boot_cpu_id __read_mostly;
> +__initdata unsigned long _brk_start, _brk_end;
> 

Better yet, initialize _brk_start and _brk_end statically:

extern const char _end[];
__initdata unsigned long _brk_start = (unsigned long)&_end;
__initdata unsigned long _brk_end   = (unsigned long)&_end;

That way it's available from the first instruction, and we can fully
remove the x86-32 init_pg_tables_end and replace it with _brk_end (thus
putting the initial page tables in the brk.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

