Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbXL3Uox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbXL3Uox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXL3Uop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:44:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXL3Uop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:44:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Date: Sun, 30 Dec 2007 22:04:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200712281353.37976.rjw@sisk.pl> <20071230142109.GK16946@elte.hu>
In-Reply-To: <20071230142109.GK16946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712302204.56977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 of December 2007, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Document the fact that __save_processor_state() has to save all CPU 
> > registers referred to by the kernel in case a different kernel is used 
> > to load and restore a hibernation image containing it.
> 
> ok - so i guess i should drop this from x86.git:
> 
>  @@ -53,7 +53,6 @@ void __save_processor_state(struct saved
>          ctxt->cr2 = read_cr2();
>          ctxt->cr3 = read_cr3();
>          ctxt->cr4 = read_cr4();
>  -       ctxt->cr8 = read_cr8();
>   }
> 
> right?

Well, if cr8 is used for anything that matters, then yes.

> But i'm wondering - are we really ever resuming to a different  
> kernel version, for this to be an issue?

The boot kernel may be different from the kernel within the image, if that's
what you're asking for.

Rafael
