Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZKZNV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZKZNV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZKZNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:21:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60105 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZKZNVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=WRfnvp7CJCMdHkUq5HgIuJUMHFSom59a35dmU8Dsjq0qOhFLZzMTo3RUNIq7kcR+TC
         fmJfBETtPdwn+bvYHqZHP93wWeWFJkVxTk9S9XFA2XF80KBsx6YdnjBIcosQE3TsGK5C
         6pzlofGvpVxEv5OVeETu+CDoIIIJNpxxw9GR0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
Date: Thu, 26 Nov 2009 14:20:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20091126121945.GB13095@csn.ul.ie> <1259240937.7371.15.camel@marge.simson.net>
In-Reply-To: <1259240937.7371.15.camel@marge.simson.net>
MIME-Version: 1.0
Message-Id: <200911261420.57121.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 02:08:57 pm Mike Galbraith wrote:
> On Thu, 2009-11-26 at 12:19 +0000, Mel Gorman wrote:
> > (cc'ing the people from the page allocator failure thread as this might be
> > relevant to some of their problems)
> > 
> > I know this is very last minute but I believe we should consider disabling
> > the "low_latency" tunable for block devices by default for 2.6.32.  There was
> > evidence that low_latency was a problem last week for page allocation failure
> > reports but the reproduction-case was unusual and involved high-order atomic
> > allocations in low-memory conditions. It took another few days to accurately
> > show the problem for more normal workloads and it's a bit more wide-spread
> > than just allocation failures.
> > 
> > Basically, low_latency looks great as long as you have plenty of memory
> > but in low memory situations, it appears to cause problems that manifest
> > as reduced performance, desktop stalls and in some cases, page allocation
> > failures. I think most kernel developers are not seeing the problem as they
> > tend to test on beefier machines and without hitting swap or low-memory
> > situations for the most part. When they are hitting low-memory situations,
> > it tends to be for stress tests where stalls and low performance are expected.
> 
> Ouch.  It was bad desktop stalls under heavy write that kicked the whole
> thing off.

The problem is that 'desktop' means different things for different people
(for some kernel developers 'desktop' is more like 'a workstation' and for
others it is more like 'an embedded device').

--
Bartlomiej Zolnierkiewicz
