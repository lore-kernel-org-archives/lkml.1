Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYGZSoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYGZSoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYGZSoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:44:34 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:4513 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYGZSod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:44:33 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot boot
From: Andi Kleen <andi@firstfloor.org>
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
	<48848DDF.6010903@zytor.com>
	<43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>
	<48851AC2.8030007@zytor.com> <20080722131408.GA12418@elte.hu>
	<4885DF9D.2090804@zytor.com> <87prp07b0y.fsf@basil.nowhere.org>
	<488B6E7B.9040908@zytor.com>
Date: Sat, 26 Jul 2008 20:44:31 +0200
In-Reply-To: <488B6E7B.9040908@zytor.com> (H. Peter Anvin's message of "Sat, 26 Jul 2008 14:35:39 -0400")
Message-ID: <87ljzo7aeo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jul 2008 18:44:25.0236 (UTC) FILETIME=[A0630D40:01C8EF4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> The real mode code *is* compiled with -march=i386, and in the CMOV
> case it will err out with a legible message.
>
> The issue isn't CMOV at all, it's with long NOPs, which don't have a
> CPUID bit -- they're supposed to be supported if family >= 6, but some
> VIA chips violate that condition.

Ah yes I realized that about 1 minute after sending the original mail %)
Sorry for the noise. The only way to handle this is probably to add
special quirks. Should check with Centaur for the exact CPUID signatures
of these CPUs.

Or perhaps just stop using the special nops. It was always unclear
if optimizing nops was really worth it.

-Andi
