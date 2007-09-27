Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbXI0OtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbXI0OtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbXI0Osz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:48:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbXI0Osz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:48:55 -0400
Date: Thu, 27 Sep 2007 07:48:49 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Module use count must be updated as bridges are
 created/destroyed
Message-ID: <20070927074849.074fdb88@freepuppy.rosehill>
In-Reply-To: <46FB7A7A.76E4.0078.0@novell.com>
References: <46FA2C17.76E4.0078.0@novell.com>
	<20070926083705.6bc65ea5@fujitsu-loaner>
	<46FAA013.76E4.0078.0@novell.com>
	<20070926101252.3ccbb987@freepuppy.rosehill>
	<46FB7A7A.76E4.0078.0@novell.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 08:40:10 +0100
"Jan Beulich" <jbeulich@novell.com> wrote:

> >>> Stephen Hemminger <shemminger@linux-foundation.org> 26.09.07 19:12 >>>
> >On Wed, 26 Sep 2007 17:08:19 +0100
> >"Jan Beulich" <jbeulich@novell.com> wrote:
> >
> >> >>> Stephen Hemminger <shemminger@linux-foundation.org> 26.09.07 17:37 >>>
> >> >On Wed, 26 Sep 2007 08:53:27 +0100
> >> >"Jan Beulich" <jbeulich@novell.com> wrote:
> >> >
> >> >> Otherwise 'modprobe -r' on a module having a dependency on bridge will
> >> >> implicitly unload bridge, bringing down all connectivity that was
> >> >> using bridges.
> >> >> 
> >> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> >>
> >> >
> >> >No, network devices don't do reference counting.
> >> >What is the dependency? Where is the source of the module interacting
> >> >with the  bridge?
> >> 
> >> On a Xen system, I loaded and then unloaded ebtable_broute. The unload
> >> implicitly unloaded bridge, destroying the network. The only way I could see
> >> to avoid the implicit unload was to bump the reference count on bridge
> >> creation. Otherwise I would have to ask why bridge has a zero reference
> >> count despite a bridge being configured.
> >> 
> >> Jan
> >
> >Sounds like a module utilities problem since unloading one module doesn't
> >normally unload others.
> 
> I have to disagree here - 'modprobe -r' is specifically unloading all modules the
> specified one references as long as they have a use count of zero. The
> difference to other networking modules is that the latter normally don't export
> symbols, and hence don't have dependent modules (and thus cannot be
> subject of implicit unloading). Bridge does have dependents, and hence must
> avoid implicit unloading by managing its use count.

I want keep the behavior that:
	modprobe -r bridge
removes all bridges.  It is too useful and may already be in some user scripts.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
