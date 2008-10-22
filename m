Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYJVOwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYJVOwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYJVOwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:52:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:24884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYJVOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ebxdQMV9OhaYvEYPult9AFxSt0qI7QIReGUMe3C7b8Rw3Gqbnff6AbzdR+pqqXpQs+
         RtKCOv3HlrLmUlmKTGxi/3KhYbj5dQaya674H8vSLpcE9oyqA5TFZcRJB1UTNpC2KRcN
         62YvxQ9tj/5sHOLeGIRluiJ2bsMalTZKfFA/0=
Date: Wed, 22 Oct 2008 18:52:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022145238.GC9639@localhost>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <20081022141720.GB9639@localhost> <20081022142312.GC26372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022142312.GC26372@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 22, 2008 at 04:23:12PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > | > -		apic_write(APIC_ESR, 0);
| > | > -		apic_read(APIC_ESR);
| > | > +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
| > | > +			apic_write(APIC_ESR, 0);
| > | > +			apic_read(APIC_ESR);
| > | > +		}
| > | 
| > | i'm wondering - is the server there really that old, that it has no 
| > | integrated lapic? I.e. it's an i486 SMP box or so? Or perhaps some 
| > | other, weird SMP box?
| > | 
| > | 	Ingo
| > | 
| > 
| > I was quite wondering too -- it's Xeon server.
| > 
| > >From http://lkml.org/lkml/2008/10/20/34
| > >> Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
| > >> Tell me if you need more detailed information.
| 
| ah, Compaq - how many CPUs does that box support? If it's 8 or more then 
| perhaps they turned off the real local APIC, fudged some chipset glue to 
| emulate APIC functionality and thus were able to use 8 or more of these 
| chips? The built-in lapic would only go up to 4 CPUs. (or maybe even 
| just up to dual, depending on the model)

I have no glue how many cpus it does supposrt :) Maybe Max know.

| 
| This reminds us that all the is-integrated-lapic checks still matter 
| today.
| 
| 	Ingo
| 
		- Cyrill -
