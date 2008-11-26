Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYKZOux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYKZOux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYKZOup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:50:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34142 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYKZOuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:50:44 -0500
Date: Wed, 26 Nov 2008 14:50:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Philip Langdale <philipl@overt.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx, drzeus@drzeus.cx, fseidel@suse.de,
       weyland@library.ethz.ch
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Message-ID: <20081126145039.GA31043@srcf.ucam.org>
References: <492BBA91.5010302@overt.org> <200811261436.57946.elendil@planet.nl> <492D604C.10707@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492D604C.10707@overt.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 06:42:20AM -0800, Philip Langdale wrote:
> Frans Pop wrote:
> >>The latest generation of laptops are shipping with a newer
> >>model of Ricoh chip where the firewire controller is the
> >>primary PCI function but a cardbus controller is also present.
> >
> >Note that the current separate ricoh_mmc disabling module approach has 
> >been shown to break during suspend/resume. Matthew Garret proposed a 
> >patch for that which (with minor fixups) I tested successfully.
> 
> Hmm. Well, I'm interested as to what Pierre thinks. He explicitly didn't
> want a quirk when we originally looked at the problem and that's why
> ricoh_mmc exists - but maybe this is a good enough reason to revisit that
> decision.

Thinking about it, it could possibly be handled by changing to 
suspend_noirq and resume_noirq rather than the normal suspend and resume 
functions? That ought to get the ordering constraints right. The problem 
occurs when ricoh_mmc suspends before sdhci and resumes after it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
