Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYFLRiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYFLRiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYFLRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:38:08 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22693 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752799AbYFLRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:38:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g/b7FqqmVxf5zwaxKbFFpfvuiZctL1IkFk8llRHvRY+UQ5WvHX9tkKAFbmI96HAPzpcmrbGz2g2xlMP3D8kGG1Rp2/22+7t7LmColdtnUCg42BuNclk+op2ZGweqLLng5OFSOq5JS2dkYjx83fqnufhi2I0fmYdE6IH+2iCfsZ8=  ;
X-YMail-OSG: E5k3nRIVM1ldTtJmlHZ3gwD.d8rYDBXLJL8bveUi6xULvR1hUbZxLN2H.6Wj5jeHVLFt.4WmSixXSfwAINFzar2eCrPaLY1V88opzt7s49.t2VCUzsDUrtmsIP_L_Z_MM5U-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm 14/24] Ramfs and Ram Disk pages are unevictable
Date: Fri, 13 Jun 2008 03:37:56 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>
References: <20080611184214.605110868@redhat.com> <200806121054.19253.nickpiggin@yahoo.com.au> <20080612132952.568226f6@cuia.bos.redhat.com>
In-Reply-To: <20080612132952.568226f6@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130337.57118.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 03:29, Rik van Riel wrote:
> On Thu, 12 Jun 2008 10:54:18 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 12 June 2008 04:42, Rik van Riel wrote:
> > > From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > >
> > > Christoph Lameter pointed out that ram disk pages also clutter the
> > > LRU lists.  When vmscan finds them dirty and tries to clean them,
> > > the ram disk writeback function just redirties the page so that it
> > > goes back onto the active list.  Round and round she goes...
> >
> > This isn't the case for brd any longer. It doesn't use the buffer
> > cache as its backing store, so the buffer cache is reclaimable.
>
> What does that mean?

That your patch is obsolete.


> I know that pages of files that got paged into the page
> cache from the ramdisk can be evicted (back to the ram
> disk), but how do the brd pages themselves behave?

They are not reclaimable. But they have nothing (directly) to do
with brd's i_mapping address space, nor are they put on any LRU
lists.
