Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYGQADn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYGQADn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbYGQADb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:03:31 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:59055 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760211AbYGQAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:03:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=p+KGMxsk4Z8o9RDflTTsPjPLNeYeKiLrMIKapXE/eYv9tOYCPDLtW3O5YO3uEg9/Z98QMLog1pgAOWcJbu24jBG7X+6wHyDF3CfypFseMM4GoVMMwT4bW0I90Z+CjiuE;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: acpi based pci gap calculation  - v3
Date: Wed, 16 Jul 2008 17:03:11 -0700
User-Agent: KMail/1.9.9
Cc: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
References: <1216148382.6135.21.camel@alok-dev1> <200807160906.43632.jbarnes@virtuousgeek.org> <487E22EA.8030005@linux.intel.com>
In-Reply-To: <487E22EA.8030005@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161703.11572.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 9:33 am Andi Kleen wrote:
> > The only problem there is that linux-next doesn't get nearly the sort of
> > testing coverage we need for this kind of change.
>
> Normally I tend to wait for one -mm release, which seems to be tested
> by a reasonable number of people. If it survives that it is good
> to be tested in Linus' tree.
>
> Just stuffing this in in literally the last minute doesn't seem
> like a good idea.

Well it's hardly last minute given that the merge window only opened a couple 
of days ago...

But beyond that, now that I've thought about it a bit more I'm not even sure 
the patch is really correct (though it works on my test machines).  Shouldn't 
we be looking at _PRS not _CRS?  And ideally we should try to find even more 
space, not less.  This patch made one of my machines lose quite a bit of 
space:

...
Allocating PCI resources starting at c0000000 (gap: bf000000:40f00000)
...
ACPI: PCI resources should start at c0000000 (gap: bf000000:31000000)
...

which is a step backwards.  With that in mind, I reverted the patch before 
asking Linus to pull; I'm hopeful we can do better though.  I'd love to never 
see "resource allocation failed" messages anymore.

Thanks,
Jesse
