Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYJHACo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYJHACo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbYJHACY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:02:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:31704 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbYJHACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n2aXcorOWjCEcH4up8+9rXHgMCkFHyNNBEJqGz9fxCgHH8SJJQdhpdY7KUONBgLLQQ
         o1e9iMHhkjKokDGqSYhI/WVLy2rQOmWk6tV9+y2CKP+S5f/u5Lhi0uvH0NiRY2Xeq7K4
         HCBMjjwOFgN/C/F6eqzANoViBNAjyBblU7sHE=
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <20081007235533.GN25780@parisc-linux.org>
References: <1223416391.8195.22.camel@brick>
	 <20081007232807.GL25780@parisc-linux.org> <1223422542.8195.42.camel@brick>
	 <20081007235533.GN25780@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 17:02:18 -0700
Message-Id: <1223424138.8195.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 17:55 -0600, Matthew Wilcox wrote:
> On Tue, Oct 07, 2008 at 04:35:42PM -0700, Harvey Harrison wrote:
> > On Tue, 2008-10-07 at 17:28 -0600, Matthew Wilcox wrote:
> > > On Tue, Oct 07, 2008 at 02:53:11PM -0700, Harvey Harrison wrote:
> > > > In addition, there are some subsystems (scsi) that are looking into some
> > > > differently sized endian helpers (be24) and it may be worthwhile to have
> > > > some agreement whether it is worth making them common infrastructure and
> > > > whether they should present a similar API to the common byteorder/unaligned
> > > > API.
> > > 
> > > I still think SCSI should have its own accessors, even if they're
> > > just wrappers around the common BE code.
> > > 
> > 
> > I thought it was generally discouraged that subsystems have trivial
> > wrappers like that, otherwise you wind up with:
> > 
> > scsi_get_u32
> > usb_get_u32
> > v4l_get_u32
> > 
> > ... and so on, where as if they all used the common names, people more
> > used to other areas of the kernel can still recognize what the code
> > is doing without having the lookup another define.
> 
> My point is that they don't have to recognise what the code is doing.
> They don't have to know if the protocol is BE or LE, only that USB code
> is accessing the data in the appropriate way for USB.
> 

Or you go the packed-struct route and use the common helpers, and sparse tells
you if you use the wrong endianness.  Even better, the structs act as decent
documentation of the data being worked on.

YMMV,

Harvey

