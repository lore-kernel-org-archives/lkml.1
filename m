Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbZDOIdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbZDOIdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbZDOIdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:33:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46661 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756653AbZDOIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:33:17 -0400
Date: Wed, 15 Apr 2009 09:33:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Mel Gorman <mel@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: meminfo Committed_AS underflows
Message-ID: <20090415093317.4f937809@lxorguk.ukuu.org.uk>
In-Reply-To: <1239737619.32604.118.camel@nimitz>
References: <1239737619.32604.118.camel@nimitz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The 1023 cpus won't ever hit the ACCT_THRESHOLD.  The 1 CPU that did
> will decrement the global 'vm_committed_space'  by ~128 GB.  Underflow.
> Yay.  This happens on a much smaller scale now.
> 
> Should we be protecting meminfo so that it spits slightly more sane
> numbers out to the user?

Yes. It used to be accurate but the changes were put in as the memory
accounting value was actually starting to show up in profiles as it
bounced around the CPUs - perhaps the constraint should instead be a
worst case error as percentage of total system memory ?

Alan
