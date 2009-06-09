Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZFIQhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZFIQhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZFIQhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:37:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbZFIQhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:37:06 -0400
Date: Tue, 9 Jun 2009 12:28:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Message-ID: <20090609162808.GC2491@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	cpufreq@vger.kernel.org
References: <4A2835D8.6040903@kernel.org> <4A2AE4AC.60805@kernel.org> <4A2AE570.2010307@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 08:46:44AM -0700, Linus Torvalds wrote:
 
 > Please STOP USING THAT HORRIBLE "work_on_cpu()" crap.
 > 
 > Is there any reason you do that? We've had to fix up the fallout from that 
 > kind of crazy crap several times.
 > 
 > Just use a regular IPI. Use "smp_call_function_[single|many]()" instead.
 > 
 > See for example commit 01599fca6758d2cd133e78f87426fc851c9ea725, where 
 > another "work_on_cpu()" thing was broken.
 > 
 > I don't understand why you guys keep on using that _known_ bad function. 
 > The whole point of "work_on_cpu()" is for big, slow, and rare things. Not 
 > as a random "let's make that CPU do this".
 > 
 > So stop it. 

work_on_cpu()'s definition could probably use a fat comment describing
why it sucks.


	Dave

