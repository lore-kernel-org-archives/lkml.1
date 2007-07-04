Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXGDKf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXGDKf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbXGDKf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:35:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760570AbXGDKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:35:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 12:42:59 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707032337.52544.rjw@sisk.pl> <18059.5690.908102.273897@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.5690.908102.273897@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041242.59552.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 05:38, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > Now, please tell me how many driver writers even thought that something
> > might try to access their devices after .suspend() had been executed (or
> > even whilie it was being executed)?
> 
> Well, I believe that the USB framework copes with this, except
> possibly for some corner cases like the example that Alan Stern
> posted.  The fact that powerbooks suspend and resume without the
> freezer implies that the IDE framework, the console code and the
> framebuffer code cope correctly (though possibly not all chipset
> drivers).

Okay, so in fact you don't know.

And that's my point in this thread.

I won't fight for the freezer for what it's worth, but let's do things in the
_right_ _order_.  For example, let's make sure that by making the $subject
change we won't introduce (too many) regressions and fix the frameworks
that don't get it right.

Using the problems with FUSE as an argument for making this change immediately
doesn't seem to be right to me.

> So I think that a lot of the frameworks already get it right.  Of
> course the quality of the low-level chipset drivers has always been
> pretty variable. :)

Yes, but that's another issue.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
