Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZLJAHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZLJAHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbZLJAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:07:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856AbZLJAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:07:44 -0500
Message-ID: <4B203B48.3070906@zytor.com>
Date: Wed, 09 Dec 2009 16:05:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86, 32-bit: Add new pt_regs stubs
References: <1260403316-5679-1-git-send-email-brgerst@gmail.com> <1260403316-5679-2-git-send-email-brgerst@gmail.com>
In-Reply-To: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 04:01 PM, Brian Gerst wrote:
> Add new stubs which add the pt_regs pointer as the last arg, matching
> 64-bit.  This will allow these syscalls to be easily merged.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> +ptregs_##name: \
> +	leal 4(%esp),%edx; \
> +	movl PT_EBX(%edx),%eax; \
> +	jmp sys_##name;

You're introducing a completely unnecessary pipeline serialization here.
 Instead do:

	movl (PT_EBX+4)(%esp),%eax;

... making the statements independent and therefore executable in parallel.

	-hpa
