Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYJGXkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYJGXkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJGXjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:39:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:26887 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbYJGXjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SnYDi8z9Pp+o3ThGgnbriXPPSy6vMvXCN/OyK35G4ixKlClmmWXNAfA7BK+KS34/mH
         /ZqgtAsX5RDDAPAdx3m7SaLDq1g5fuz2BP0oYZRaFpKr7Be/fyz9XSVv1Hp4pxA8Wpxl
         9gjC5LDo/eTRFeUJMzIXtXq0Hv3v6YfkcV7HM=
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <20081007233315.GM25780@parisc-linux.org>
References: <1223416391.8195.22.camel@brick>
	 <1223417543.7484.7.camel@localhost.localdomain>
	 <1223419166.8195.37.camel@brick>  <20081007233315.GM25780@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 16:39:48 -0700
Message-Id: <1223422788.8195.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 17:33 -0600, Matthew Wilcox wrote:
> On Tue, Oct 07, 2008 at 03:39:25PM -0700, Harvey Harrison wrote:
> > As an example, in the write command handling in achba.c, a patch similar to the following
> > (assumes the existence of a __be24 type somewhere):
> 
> What type could be defined to be '__be24'?  Would
> 
> typedef struct {
> 	unsigned char data[3];
> } __be24;

__packed

> 
> do the trick?  It's not an integral type, but I'm not sure if that matters.
> 
> > +				cmnd_lba = unaligned_be24_to_cpup(&tmp->lba) & 0x001FFFFF;
> 
> That might be easier to read if you're using a 500-column terminal.  For
> the rest of us,
> 				cmnd_lba = scsi_get_u24(cmnd + 2) & 0x1FFFFF;
> is much easier to read.

Suggestions welcome on shorter common names for the unaligned helpers.

Cheers,

Harvey



