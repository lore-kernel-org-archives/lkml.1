Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbXFDSOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbXFDSOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbXFDSOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:14:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51450 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbXFDSOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:14:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	<200706011407.51779.jbarnes@virtuousgeek.org>
	<20070601211943.GO7217@one.firstfloor.org>
	<200706011441.57149.jbarnes@virtuousgeek.org>
Date: Mon, 04 Jun 2007 12:13:12 -0600
In-Reply-To: <200706011441.57149.jbarnes@virtuousgeek.org> (Jesse Barnes's
	message of "Fri, 1 Jun 2007 14:41:57 -0700")
Message-ID: <m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
>> And normally the MTRRs win, don't they (if I remember the table correctly)
>> So if the MTRR says UC and PAT disagrees it might not actually help
>
> I just checked, yes the MTRRs win for UC types.  But it sounds like the cases 
> we're talking about are actually situations where there's no MTRR coverage, 
> so the default type is used.  The manual doesn't specifically call out how 
> memory using the default type interacts with PAT, but it may well be that it 
> stays uncached if the default type is uncached.  Again that argues for fixing 
> the MTRR mapping problem in some way.

Last I looked PAT can only demote not promote the type of a page,
except for the specific exception of UC to WC.

Normally the default type is UC so putting a pat type of WB won't
help anything.  I may have missed some subtle detail but I remember
looking into this in some detail a while ago and coming to that
conclusion.

It is the BIOS's responsibility to mark all usable memory as WB,
using the MTRRs.  If it doesn't it is a BIOS bug.

Eric
