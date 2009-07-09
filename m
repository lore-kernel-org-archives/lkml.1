Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZGID7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZGID7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZGID6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:58:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZGID6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:58:49 -0400
Message-ID: <4A556AB7.6000209@zytor.com>
Date: Wed, 08 Jul 2009 20:57:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Len Brown <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 08/12] SFI, x86: hook e820() for memory map initialization
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>	<5bf6b3c7c08a76ea8dc52e9e07728c2958938952.1247025117.git.len.brown@intel.com>	<4A551184.1020707@zytor.com> <20090709091141.19652887@feng-desktop>
In-Reply-To: <20090709091141.19652887@feng-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng Tang wrote:
> 
> Hi hpa,
> 
> I understand your concern, and I've added that code into our boot loader
> for Moosrestown which sets up a e820 memory table in boot parameters by 
> parsing SFI table. 
> 
> The reason we still keep this piece of code is to be compatible with old
> version boot loaders which may not know SFI info yet. And
> sfi_init_memory_map() only get called when kernel can't find an e820 table
> in boot parameters.
> 
> Anyway, I think we can remove the code if it really breaks the rule.
> 
> Thanks,
> Feng
> 

What I'm concerned about is that we will want to be able to use the
range allocator, which relies on the e820 memory map, extremely early
during boot.  In the EFI case, we allow (*optionally*) to fill in
additional information from the EFI map after initial boot, but we still
require memory ranges in the initial map (they can, however, be a subset
of the available memory.)

I'm really concerned about saying "well, it works now" and tying
ourselves into an interface that we cannot support in the long term
(read: we'll be stuck with it.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

