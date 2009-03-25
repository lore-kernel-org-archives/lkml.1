Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbZCYX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbZCYX7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZCYX7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:59:04 -0400
Received: from gw.goop.org ([64.81.55.164]:38162 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZCYX7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:59:03 -0400
Message-ID: <49CAC543.5020205@goop.org>
Date: Wed, 25 Mar 2009 16:58:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
References: <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain> <49CABB25.8040106@goop.org> <20090325232921.GL7278@localdomain>
In-Reply-To: <20090325232921.GL7278@localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> The point in this thread was, is_vsmp_box() needs to be meaningful even when
> CONFIG_X86_VSMP is not on.  This is needed because is_vsmp_box() is used to
> determine if the platform has reliable tscs.
>   

Well, as I said, that code is inoperative at present.  But aside from 
that, how well will a non-VSMP kernel work on your hardware, with a 
normal cacheline, etc.  Is the tsc stability really all that important, 
given that the kernel should notice if the tsc is busted pretty quickly 
anyway.

unsynchronized_tsc() just returns a guess anyway, and if you don't have 
X86_FEATURE_CONSTANT_TSC set, then it will return unstable for your 
hardware anyway, even without the is_vsmp_box() test.

Failing that, you could add yourself to bad_tsc_dmi_table[] and have 
that mark the tsc as unstable (you have DMI, right?).

    J


