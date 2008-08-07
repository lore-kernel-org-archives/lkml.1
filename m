Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYHGXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYHGXqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYHGXqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:46:32 -0400
Received: from gw.goop.org ([64.81.55.164]:58398 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbYHGXqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:46:30 -0400
Message-ID: <489B8948.6060003@goop.org>
Date: Thu, 07 Aug 2008 16:46:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org>
In-Reply-To: <489B84EF.6050009@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The fixmap area should never have been made movable.  It's utter 
> braindamage.

Shrug.  It's been like that for a couple of years now.  It was one of 
the very first paravirt-ops patches.  It wasn't controversial then, and 
nobody seems to have noticed since.

> Given the x86 architecture, it's inevitable that PV will want to 
> reserve address space at the top of memory, and therefore the fixmap 
> area needs to be moved out of that space.

OK.  But there's a few places where the code uses FIXADDR_TOP to mean 
"top of kernel address space", so we'd need to come up with a proper 
symbol for that.

    J
