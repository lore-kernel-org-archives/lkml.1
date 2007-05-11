Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbXEKBFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbXEKBFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbXEKBFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:05:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57686 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbXEKBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:05:00 -0400
Date: Fri, 11 May 2007 10:05:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: y-goto@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@osdl.org, mel@csn.ul.ie
Subject: Re: [RFC] memory hotremove patch take 2 [05/10] (make basic remove
 code)
Message-Id: <20070511100546.6464c711.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705101108251.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120512.B910.Y-GOTO@jp.fujitsu.com>
	<Pine.LNX.4.64.0705101108251.10002@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 11:09:29 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 9 May 2007, Yasunori Goto wrote:
> 
> > +/*
> > + * Just an easy implementation.
> > + */
> > +static struct page *
> > +hotremove_migrate_alloc(struct page *page,
> > +			unsigned long private,
> > +			int **x)
> > +{
> > +	return alloc_page(GFP_HIGH_MOVABLE);
> > +}
> 
> This would need to reflect the zone in which you are performing hot 
> remove. Or is hot remove only possible in the higest zone?
> 
No. We'll allow hot remove in any zone-type.
My old patchest didn't include Mel-san's page grouping and just had
ZONE_MOVABLE, so I wrote this. Reflecting migration target's zone here
is reasobanle. 

Anyway, I think we'll need more complicated function here.

Thanks,
-Kame

