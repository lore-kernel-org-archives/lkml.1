Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZJZLfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZJZLfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZJZLfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:35:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52683 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbZJZLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:35:00 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 07:35:00 EDT
Subject: Re: [PATCH][RE-SUBMIT] Default setting of the ARM_UNWIND option
From: Catalin Marinas <catalin.marinas@arm.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
       linux-arm-kernel@lists.arm.linux.org.uk, akpm@linux-foundation.org
In-Reply-To: <4AE55D83.7080608@evidence.eu.com>
References: <4AD73DA4.4050006@evidence.eu.com>
	 <1255620333.10164.77.camel@pc1117.cambridge.arm.com>
	 <4AE55D83.7080608@evidence.eu.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 26 Oct 2009 11:10:52 +0000
Message-Id: <1256555452.5282.21.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2009 11:10:53.0271 (UTC) FILETIME=[FB927670:01CA562C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 09:27 +0100, Claudio Scordino wrote:
> My ARM board hanged at the initial "Calibrating delay loop" message.
> 
> After some inspection, I found out the problem to be with commit
> adf8b37bafc1495393201a2ae4235846371870d0. This commit introduces stack
> unwinding for ARM, and set it enabled by default. However, it seems to
> not work with buggy or not-EABI compilers.
> 
> My suggestion is to keep the feature (which is fine) but change the
> default setting of the option (see the attached patch).

The option still depends on EXPERIMENTAL, so you get ARM_UNWIND on when
enabling that.

I'm more in favour of a #warning on #error in the unwind.c file based on
the compiler version rather than not having it on by default. The reason
is that people reported performance improvements when compiling the
kernel without frame pointers.

-- 
Catalin

