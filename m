Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbZGCU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbZGCU5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZGCU5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:57:15 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52620 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZGCU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:57:14 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Brad Boyer <flar@allandria.com>
Cc: kernel mailz <kernelmailz@googlemail.com>, linuxppc-dev@ozlabs.org,
       gcc-help@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: Inline assembly queries [2]
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
	<20090703174031.GA12410@cynthia.pants.nu>
X-Yow: I am a traffic light, and Alan Ginsberg kidnapped my laundry in 1927!
Date: Fri, 03 Jul 2009 22:57:12 +0200
In-Reply-To: <20090703174031.GA12410@cynthia.pants.nu> (Brad Boyer's message
	of "Fri, 3 Jul 2009 10:40:31 -0700")
Message-ID: <m23a9deb87.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Boyer <flar@allandria.com> writes:

> On Fri, Jul 03, 2009 at 12:14:41PM +0530, kernel mailz wrote:
>> b. using m or Z  with a memory address. I tried replacing m/Z but no change
>> Is there some guideline ?
>> gcc documentation says Z is obsolete. Is m/Z replaceable ?
>
> No idea. I don't remember ever seeing 'Z' used in anything. Maybe somebody
> else remembers what it used to mean.

The 'Z' constraint is required for a memory operand for insns that don't
have an update form (which would be selected by the %U modifier).  It
should only be used together with the %y operand modifier, which makes
sure that the first register is never 0.  If the 'm' constraint were
used the operand could contain a pre-in/decrement operation, and without
%U the side effect would be lost.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
