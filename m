Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0BDR4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:56:07 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6516 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0BDR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:56:05 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v1 0/7] PCI: try enabling "pci=use_crs" again
Date: Thu, 4 Feb 2010 10:55:57 -0700
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20100203233617.10803.92102.stgit@bob.kio> <4B6A4F17.2080806@lwfinger.net>
In-Reply-To: <4B6A4F17.2080806@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002041055.58953.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010 09:37:43 pm Larry Finger wrote:
> On 02/03/2010 05:38 PM, Bjorn Helgaas wrote:
> > Larry, you reported the problem the last time I tried to turn on "pci=use_crs"
> > by default.  This series shouldn't affect your machine because it's not in the
> > whitelist, but I expect that if you boot the current kernel with "pci=use_crs",
> > it should still fail, and if you boot with these patches and "pci=use_crs", it
> > *should* work.  I know it's a lot to ask, but it'd be great if you had a chance
> > to try that.
> 
> On my system, "git describe" returns v2.6.33-rc6-146-gc80d292. Patch 1 does not
> apply and can be reverted. That is not a problem, but beginning with patch 5,
> these do not apply.

Looks like you're using Linus' tree.  My patches go on top of Jesse's
PCI linux-next tree.  Here's how you can do this (assuming you have
stgit as well as git):

  Save all the patches in files "/tmp/use-crs.1" through "/tmp/use-crs.7".
  These can be plain email; you don't have to remove headers or
  anything.

  $ cd <git repo>
  $ git branch
  $ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git linux-next
  $ stg branch -c use-crs 0148b041be4e7
  $ for F in `seq 7`; do stg import -m /tmp/use-crs.$F; done

Now you should have a tree with all the patches applied.

After you're done testing, to return to where you were before, use
"git checkout <branch>" where <branch> is the name marked with a "*"
from the very first "git branch" command.

> In addition to the above, my system now boots with "pci=use_crs", unlike when I
> filed the Bugzilla.

Huh.  From http://lkml.org/lkml/2009/6/24/11, I had assumed the main
problem was that we overflowed the 16-entry bus resource table, but
there must be more to it.

If you can build and boot the linux-next branch with my patches and
collect the dmesg log, maybe it will have a clue.  You can boot without
"pci=use_crs"; I don't think that will make any difference on your box.

Bjorn
