Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYAJVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYAJVLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAJVLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:11:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbYAJVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:11:32 -0500
Date: Thu, 10 Jan 2008 13:05:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity
 map and kernel text
In-Reply-To: <20080110184854.787474000@intel.com>
Message-ID: <alpine.LFD.1.00.0801101303570.3148@woody.linux-foundation.org>
References: <20080110184840.927409000@intel.com> <20080110184854.787474000@intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, venkatesh.pallipadi@intel.com wrote:
>
> x86_64: Map only usable memory in identity map. All reserved memory maps to a
> zero page.

I don't mind this horribly per se, but why a zero page?

Accessing that page without mapping it explicitly would be a bug with 
your change - if only because you'd get the wrong value!

So why map it at all? The only thing mapping it can do is to hide bugs.

			Linus
