Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYFRRXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYFRRXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYFRRXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:23:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:13206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYFRRXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dU+D7pjbbv1zPsDopr7xmMhMWMBUaX8FxIDRJSP92lWhHsarIad17c8DIBsarngGl+
         WUOLsgn33iQLCVku/yZaIN5IHkDn/aZmPRnPchRp9BzoLsO4JzkP52jwmGC5aZWlCEXc
         5i1bd6WvalVwGcbLvq5ev3KtHTovz7ogzxlqY=
Date: Wed, 18 Jun 2008 21:23:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
Message-ID: <20080618172316.GA10431@cvg>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl> <20080616170000.GC7273@cvg> <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl> <20080617155120.GA9440@cvg> <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl> <20080618163905.GB7117@cvg> <Pine.LNX.4.55.0806181749050.4857@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806181749050.4857@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, Jun 18, 2008 at 05:54:32PM +0100]
| On Wed, 18 Jun 2008, Cyrill Gorcunov wrote:
| 
| > Maciej, it seems we are talking about different code snippets ;)
| > I'm talking only about touch_nmi_watchdog(). By now (in -tip tree
| > we have)
| > 
| > void touch_nmi_watchdog(void)
| > {
| > 	if (nmi_watchdog == NMI_LOCAL_APIC ||
| > 		nmi_watchdog == NMI_IO_APIC) {
| > 		unsigned cpu;
| > 		...
| > 
| > so we check explicitly the values (so if touch_nmi_watchdog
| > was called when nmi_watchdog = 0 or -1U this code will not
| > be executed anyway). So I think I'm a bit lost, Maciej... I just
| > can't figure out what is wrong with this code, so please help
| > me ;). If you're talking about apic code in _general_ design
| > then...well, I think I need some time to _understand_ the code
| > say byte-by-byte first.
| 
|  The value of nmi_watchdog being NMI_IO_APIC or NMI_LOCAL_APIC does not 
| mean the watchdog has been set up already.  This observation applies both 
| here and elsewhere, e.g. to nmi_watchdog_tick().
| 
|   Maciej
|

If you mean the case we get NMI physical line assetred while configuring APIC
(ie nmi watchdog is not properly configured yet) then I wonder why we has
this checking at all...

		- Cyrill -
