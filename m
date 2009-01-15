Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbZAODfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbZAODfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZAODfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:35:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZAODfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:35:08 -0500
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] conditionalize call from panic() to smp_send_stop()
From: Andi Kleen <andi@firstfloor.org>
References: <496DE7CD.76E4.0078.0@novell.com>
Date: Thu, 15 Jan 2009 04:34:32 +0100
In-Reply-To: <496DE7CD.76E4.0078.0@novell.com> (Jan Beulich's message of "Wed, 14 Jan 2009 12:25:33 +0000")
Message-ID: <87wscxdyyf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:

> ... avoiding nested warnings and/or oopses as much as possible (namely
> durin early boot).

Better would be to fix smp_send_stop than to work around it for this
very limited case. I've been running into this with machine checks
too. The new fancy smp_call_function() that is there now just doesn't
work in any unusual situation like early boot or fatal exceptions,

My thinking was to use a separate vector, or possible just the NMI.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
