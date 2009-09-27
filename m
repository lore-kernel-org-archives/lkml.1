Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZI0K2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZI0K2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 06:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZI0K2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 06:28:05 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54774 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbZI0K2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 06:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rM1Oj+8sW01qNoLQ6Egrw09DXHC2Rnd17L4PALk72C7TgW0Iqvi1RAYBi2UFEIp1lC
         rXQEYrxy/pvc5Jc+BDK4+2vAPBHBkoT7RNbfvnKWz8HopHrfYRJKLD7uvo3tYL4TeD1K
         zFXXyCcn14q/oMw5He6y2TElkEKTZUeH7ccfM=
Date: Sun, 27 Sep 2009 14:28:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add show_lapic=
Message-ID: <20090927102805.GC4984@lenovo>
References: <4ABF0DE0.1030400@kernel.org> <20090927080605.GA4984@lenovo> <4ABF2262.3090905@kernel.org> <20090927085406.GB4984@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927085406.GB4984@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Sep 27, 2009 at 12:54:06PM +0400]
| [Yinghai Lu - Sun, Sep 27, 2009 at 01:29:22AM -0700]
| | Cyrill Gorcunov wrote:
| | > [Yinghai Lu - Sun, Sep 27, 2009 at 12:01:52AM -0700]
| | > | 
| | > | so could use that together with apci=debug to print less cpu apic.
| | > | 
| | > | otherwise for system have more cpus will take a while
| | > | 
| | > | also move apic_verbosity check to print_all_ICs
| | > | 
| | > | Signed-off-by: Yinghai Lu <yinghai@kernel.org>
| | > | 
| | > | ---
| | > |  arch/x86/kernel/apic/io_apic.c |   42 ++++++++++++++++++++++++++---------------
| | > |  1 file changed, 27 insertions(+), 15 deletions(-)
| | > ...
| | > 
| | > Hi Yinghai, good idea!
| | > 
| | > I've tuned your patch a bit together with changelog.
| | > 
| | > 1) show_lapic=1 by default does change current kernel behaviour
| | >    so it should be set to max cpu available.
| | 
| | think about system with lots of cpu. but i still want to use apic=debug
| 
| but you should not change current behaviour. starting with this change
| I'll get only first apic dump, so if I don;t know how many apics I have
| what the number I should pass? Does it mean I would need to
| pass say show_lapic=2, or 4, or 6 or whatever  _all-the-time_ to be sure
| my Core2Duo prints all lapics?
| 
| | 
| | > 2) show_lapic contains the max number of lapics being printed
| | >    so we need to count them instead of plain comparation with
| | >    cpu number, as a result I've changed print_local_APICs. Or
| | >    you meant _exactly_ cpuid number? In meaning like
| | >    show_lapic=max_cpuid. Hmm?
| | > 
| | your change anything about that. there is not gap between cpu id.
| 
| you walk with for_each_online_cpu with is not the same
| as for_each_present_cpu. yes, at this stage we hardly get
| the situation when cpu initialized and then suddenly get
| offline status but anyway
| 
| | 
| | YH
| | 
| 	-- Cyrill

Also and your and my "update" (that named :-) missed the fact that get_option
may return without set argument at all, so num should be explicitly
initialized as well (in setup_show_lapic).

	-- Cyrill
