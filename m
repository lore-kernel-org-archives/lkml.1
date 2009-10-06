Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZJFNeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZJFNeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbZJFNeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:34:12 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:43346 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbZJFNeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:34:11 -0400
Date: Tue, 6 Oct 2009 15:33:31 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ext-phil.2.carmody@nokia.com
Cc: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Kobject: bail early if no new_parent in
 kobject_move()
Message-ID: <20091006153331.58287b5c@gondolin>
In-Reply-To: <1254819129.23533.27.camel@pcarmody-desktop>
References: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
	<20091005183753.4d77afcb@gondolin>
	<1254819129.23533.27.camel@pcarmody-desktop>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-1?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-1?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 11:52:09 +0300,
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> On Mon, 2009-10-05 at 18:37 +0200, ext Cornelia Huck wrote:
> > On Thu,  1 Oct 2009 17:50:48 +0300,
> > Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> > 
> > > From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > > 
> > > In the absense of kobj->kset, new_parent would remain NULL.
> > > NULL-dereference shenanighans then ensues in the subsequent
> > > sysfs_move_dir(..., new_parent) call. Bail early instead.
> > 
> > But sysfs_move_dir(..., NULL) should work and fall back to the sysfs
> > root...
> 
> I guess there are two schools of thought - the strict and the
> accommodating. I was contemplating resending an even stricter patch, but
> there's nothing wrong with adopting sane safe fallbacks instead. 

I made all the *_move() functions legal for a NULL destination (see
c744aeae9d173a953b771a7ad5c872f91fa99dec), so I'd like to have it back
that way :)

I've put the patch on my s390 system and ran through sysfs_move();
proper patch posting follows.
