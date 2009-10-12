Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZJLRdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZJLRdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbZJLRdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:33:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbZJLRdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:33:40 -0400
Message-ID: <4AD36723.5040502@zytor.com>
Date: Mon, 12 Oct 2009 10:28:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org,
       arjan@infradead.org, hmh@hmh.eng.br, rdreier@cisco.com,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/pat] x86: Relegate CONFIG_PAT and CONFIG_MTRR configurability
 to EMBEDDED
References: <20091011103302.62bded41@infradead.org> <tip-c03cb3149daed3e411657e3212d05ae27cf1a874@git.kernel.org>
In-Reply-To: <tip-c03cb3149daed3e411657e3212d05ae27cf1a874@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 04:10 AM, tip-bot for Arjan van de Ven wrote:
> Commit-ID:  c03cb3149daed3e411657e3212d05ae27cf1a874
> Gitweb:     http://git.kernel.org/tip/c03cb3149daed3e411657e3212d05ae27cf1a874
> Author:     Arjan van de Ven <arjan@infradead.org>
> AuthorDate: Sun, 11 Oct 2009 10:33:02 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 12 Oct 2009 13:06:57 +0200
> 
> x86: Relegate CONFIG_PAT and CONFIG_MTRR configurability to EMBEDDED
> 
> MTRR and PAT support (which got added to CPUs over 10 years ago)
> are no longer really optional in that more and more things are
> depending on PAT just working, including various drivers and newer
> versions of X.  (to not even speak of MTRR)
> 
> Having this as a regular config option just no longer makes sense.
> 
> This patch relegates CONFIG_X86_PAT to the EMBEDDED category so
> ultra-embedded can still disable it if they really need to.
> 

Should we combine this with removing the whitelist (which is largely
vestigial at this point) and replace it with a blacklist (possibly
empty)?  I still haven't seen any evidence that there are any CPUs which
have problems, and PAT support go back all the way to Pentium III -- and
page table attributes can be used all the way back to 386, it just
excludes the WC type.

	-hpa
