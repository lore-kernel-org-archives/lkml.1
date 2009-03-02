Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZCBAu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZCBAu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZCBAuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:50:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34441 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCBAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:50:16 -0500
Message-ID: <49AB2C78.9010401@zytor.com>
Date: Sun, 01 Mar 2009 16:46:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org> <87eixi35ew.fsf@basil.nowhere.org> <49AB1B75.2060200@goop.org> <49AB1FB8.607@zytor.com> <49AB2387.8040002@goop.org> <49AB24E0.5020604@zytor.com> <49AB2B7B.2000103@goop.org>
In-Reply-To: <49AB2B7B.2000103@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> What do you define as "full PAT"?  If what you mean is that Xen lays
>> claims to the PAT MSR and only allows a certain mapping that's hardly
>> a problem... other than that it's not an exhaustible resource so I
>> guess I really don't understand what you're trying to say here.
> 
> It does not allow guests to set their own PAT MSRs.  It can't easily be
> multiplexed either, as all CPUs must have the same settings for their
> PAT MSRs.  I guess it could be handled by allowing domains to set their
> own virtual PAT MSRs, and then rewriting the ptes to convert from the
> guest PAT settings to Xen's, but I don't know if this is possible in
> general (and it poses some problems because the pte modifications would
> be guest-visible).
> 

It would make a lot more sense to simply specify a particular set of
mappings.  Since the only one anyone cares about that isn't in the
default set is WC anyway, it's easy to do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

