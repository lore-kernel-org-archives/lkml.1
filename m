Return-Path: <linux-kernel-owner+w=401wt.eu-S1751166AbZDNPls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbZDNPls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZDNPlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:41:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48530 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZDNPlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:41:39 -0400
Subject: Re: [PATCH 10/30] cr: core stuff
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090414152752.GC27461@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain>
	 <20090413214701.GA24509@us.ibm.com>
	 <20090414152752.GC27461@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 08:41:34 -0700
Message-Id: <1239723694.32604.62.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 19:27 +0400, Alexey Dobriyan wrote:
> > Also, since Dave introduced the fops->checkpoint(), we (or at least I)
> > have been struck by the ugly assymetry with checkpoint() being in fops,
> > and restart() not.  Do you have an idea for fixing that?
> 
> Module can legally support C/R for its files.
> 
> In the end it most certainly will end up with module registering restart
> hook for file type N.
> 
> Or module registering hook to restart object type N.

Yeah, that was my expectation as well.  There's a point when we just
have too many kinds of checkpoint objects and the switch statements get
out of hand.  Oversimplified, of course, but:

	init_restart_handler(CR_FD_GENERIC, restore_generic_fd);
	init_restart_handler(CR_FD_SOCKET, restore_socket);
	init_restart_handler(CR_FD_PIPE, restore_pipe);

The only question to me is whether we allow the handler functions to do
further reading of the checkpoint image or whether the higher-level code
should be feeding them all the data they'll need in some way.

-- Dave

