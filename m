Return-Path: <linux-kernel-owner+w=401wt.eu-S932402Ab0AFRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab0AFRXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325Ab0AFRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:23:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab0AFRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:23:43 -0500
Date: Wed, 6 Jan 2010 12:23:19 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       Artem Bityutskiy <dedekind@infradead.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100106172319.GA25046@infradead.org>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com> <87eim4dbzw.fsf@basil.nowhere.org> <20100105122101.GR13802@discord.disaster> <20100105125234.GD1778@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105125234.GD1778@basil.fritz.box>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:52:35PM +0100, Andi Kleen wrote:
> > > Also it would seem cleaner to have it in a own file.
> > 
> > That might make sense if we had a large number of generic sort
> > functions and it was difficult to tell the code apart, but we've
> > only got 2 right now....
> 
> I was more thinking of the case that it can be easily made a lib-y
> and then eliminated by the linker on non modular kernels if not needed
> (unfortunately that would require putting the EXPORT_SYMBOL somewhere else)

lib-y doesn't work together with EXPORT_SYMBOL, having the export
outside would also always pull it in.  These days the whole lib-y mess
doesn't make sense anymore - if we really need an optional library
symbol we can just pull it in through a Kconfig variable.

