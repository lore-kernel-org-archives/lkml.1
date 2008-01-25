Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYAYFVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYAYFVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYAYFUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:20:54 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:44194 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659AbYAYFUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:20:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K6NLvIa1/lS46/sWqzNFuRE5oIz5P9Z2OxpJSvNXLjNbiq4kj/fPIrhpjK0dL5+hdWECyZkJOT1Locln14UmAKGh9rphjYInLdW2DCezk7LqUPaP4TtbFBIZj+rg6PiDMH8ty2FBbZBTt8dpORtmUREiquiOwPznwEIA9tc60lA=  ;
X-YMail-OSG: BlIEiXYVM1lOdAgSizOBxjutSOQEIAvCvIsWUWw_MkhZmmGyFoExZB0CbWKLiW3bjkSRfK8oCA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC] some page can't be migrated
Date: Fri, 25 Jan 2008 16:20:38 +1100
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, clameter <clameter@sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com> <200801251403.23236.nickpiggin@yahoo.com.au> <1201230571.28282.2.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1201230571.28282.2.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251620.38236.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 14:09, Shaohua Li wrote:
> On Fri, 2008-01-25 at 14:03 +1100, Nick Piggin wrote:
> > On Wednesday 23 January 2008 17:22, Shaohua Li wrote:
> > > Anonymous page might have fs-private metadata, the page is truncated.
> > > As the page hasn't mapping, page migration refuse to migrate the page.
> > > It appears the page is only freed in page reclaim and if zone watermark
> > > is low, the page is never freed, as a result migration always fail. I
> > > thought we could free the metadata so such page can be freed in
> > > migration and make migration more reliable?
> >
> > Anonymous pages should not have fs-private metadata.
> >
> > Orphaned pages I guess you mean?
>
> yes, maybe, but the comments in truncate_complete_page called the page
> anonymous.

Ah, I see. I think we should use orphaned (or anything except
anonymous) to describe these pages.
