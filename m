Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbXE3Xbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbXE3Xbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXE3Xbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:31:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751289AbXE3Xbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:31:36 -0400
Date: Wed, 30 May 2007 16:31:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: RE: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Luck, Tony wrote:

> 
> > `.exit.text' referenced in section `.init.text' of drivers/built-in.o: 
> > defined in discarded section `.exit.text' of drivers/built-in.o
> 
> 
> This one is a fatal error ... the code is trying to call a function
> that has been marked __exit in a driver that has been built-in, instead
> of as a module.  Since a builtin driver can never be unloaded, the kernel
> has thrown away all the __exit routines (at link time).
> 
> The error message appears less than helpful in tracking down which
> routine in which driver is the problem though.

Right. I have no idea where to look. The function has no name? Or is the 
segment .exit.text referenced by namne in .init.text?


