Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbZGQIB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbZGQIB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934195AbZGQIB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:01:58 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:44414 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934194AbZGQIB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:01:58 -0400
Subject: Re: [PATCH] ttm: add pool wc/uc page allocator
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <1247762075.12808.2.camel@localhost>
References: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
	 <1247762075.12808.2.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Jul 2009 10:01:51 +0200
Message-Id: <1247817711.9922.63.camel@thor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 18:34 +0200, Jerome Glisse wrote: 
> On Thu, 2009-07-16 at 18:13 +0200, Jerome Glisse wrote:
> > On AGP system we might allocate/free routinely uncached or wc memory,
> > changing page from cached (wb) to uc or wc is very expensive and involves
> > a lot of flushing. To improve performance this allocator use a pool
> > of uc,wc pages.
> > 
> > Currently each pool (wc, uc) is 256 pages big, improvement would be
> > to tweak this according to memory pressure so we can give back memory
> > to system.
> > 
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> 
> Just a follow-up on that one, i haven't been able yet to thoroughly
> test this patch on AGP system, so i am mostly sending so other people
> can test. I think i corrected few bugs that were in previous iteration
> of that patch.
> 
> Beside that i think i have addressed all comment previously raisen,
> but don't hesitate to pin point any things i have miss.

This one works a little better on my PowerBook than the previous one:

PCI GART works (failed to allocate the ring buffer before)
AGP fails to allocate the ring buffer (paniced at KMS init before)


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
