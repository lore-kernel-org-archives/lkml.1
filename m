Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbXHOQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbXHOQsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXHOQse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:48:34 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56495 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbXHOQsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:48:33 -0400
Date: Wed, 15 Aug 2007 09:47:29 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>, kiran@scalemp.com,
       shai@scalemp.com
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Message-ID: <20070815164729.GU3672@sequoia.sous-sol.org>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de> <46C31736.2050001@redhat.com> <20070815163640.GJ3406@bingen.suse.de> <46C3283B.5090804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C3283B.5090804@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Glauber de Oliveira Costa (gcosta@redhat.com) wrote:
> As alternatives what we have now, we can either keep the paravirt_ops as 
> it is now for the native case, just hooking the vsmp functions in place 
> of the normal one, (there are just three ops anyway), refill the 
> paravirt_ops entirely in somewhere like vsmp.c, or similar (or maybe 
> even assigning paravirt_ops.fn = vsmp_fn on the fly, but early enough).

This is the best (just override pvops.fn for the few needed for VSMP).
The irq_disabled_flags() is the only problem.  For i386 we dropped it
(disabled_flags) as a pvop and forced the backend to provide a flags
(via save_flags) that conforms to IF only.

thanks,
-chris
