Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYFJVjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYFJVjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbYFJVjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:39:33 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:30877 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYFJVjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:39:32 -0400
Date: Tue, 10 Jun 2008 14:39:16 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Doug Thompson <norsk5@yahoo.com>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>
Subject: Re: on static kobjects and double frees...
Message-ID: <20080610213916.GC28572@ajones-laptop.nbttech.com>
References: <20080610163800.GA28572@ajones-laptop.nbttech.com> <879085.21951.qm@web50106.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <879085.21951.qm@web50106.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug, ...

On Tue, Jun 10, 2008 at 02:14:30PM -0700, Doug Thompson wrote:
> [...]
> Arthur, thanks for tracking that down and reviewing it. All the memory controller kobjects are all
> dynamic. [...]

You're welcome, I learned a lot about kobjects
that I should have already known...

AFAICS, mc is not quite clean yet, though, as
mc_kset is static and I don't think that is right.
It does, however, look like less work than edac_pci_sysfs.c...

> [...] The edac PCI code needed to be refactored and it looks like you did it.

I only did the bare minimum, there's a lot of kobject
stuff in there that looks suspect to me, e.g.:

* the "pci" object should be a kset rather than a kobject?
* if the "pci" object is a kset, can the whole global list
  thing in edac_pci just go away?
* do we really need the atomic_inc counter, wouldn't a mutex
  be clearer?
* can we initialize "pci" at init time thereby removing the
  need even for a mutex on the "pci" initializer?  This does
  change the sysfs semantics slightly, though, as the "pci"
  object would no longer be created lazily.  I'm not sure if
  that's a problem.

and other minor things.  It looks to me like it could
use a thorough scrubbing.  The good news is that I don't
think the API would change much if at all.  I can have a
closer look if you are interested...

Arthur
