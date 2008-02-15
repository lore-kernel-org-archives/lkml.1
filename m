Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbYBOF3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbYBOF3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYBOF3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:29:14 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:54349 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYBOF3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:29:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xVSbSEZOjuSeAeMzqVWhFTlTozeoi6QopMMP7aMvqY3FMaqFYf0/3ED4oYPgEJRsAvWqL+rpNvC6uJCZieLJMDOruZI1xWiPkYjvxcAVElFs+NZp2cgilIu6RoZNI+IGCRLt4/Om/tLwsFNnPJaIvC7AVzbBPdCr+PyNE8MWPeE=
Message-ID: <e9c3a7c20802142129m51acf21amc48eaea5db45840b@mail.gmail.com>
Date: Thu, 14 Feb 2008 22:29:11 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: dma engine drivers for 2.6.25?
Cc: "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Zhang Wei" <wei.zhang@freescale.com>
In-Reply-To: <DC488215-D313-41E0-A98A-1C90D02A465D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BEF96263-F31B-472E-B31F-0751F5ABFBDA@kernel.crashing.org>
	 <e9c3a7c20802141014k6018f6dfvc1a97bf81acb872e@mail.gmail.com>
	 <DC488215-D313-41E0-A98A-1C90D02A465D@kernel.crashing.org>
X-Google-Sender-Auth: cdd130b799cf2ce6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 8:44 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
>  On Feb 14, 2008, at 12:14 PM, Dan Williams wrote:
>
>  > On Wed, Feb 13, 2008 at 8:52 PM, Kumar Gala
>  > <galak@kernel.crashing.org> wrote:
>  >> Dan,
>  >>
>  >> What's going on with the dma engine drivers for 2.6.25?  We had a
>  >> Freescale dma driver from Zhang Wei queued up but seems to have been
>  >> lost.
>  >
>  > I pulled it into my tree and am holding it until Zhang has an
>  > opportunity to address the pending review comments [1].  I also did
>  > not feel comfortable pushing it to Linus without a PPC maintainer's
>  > Acked-by/Reviewed-by.
>  >
>  > I have attached the version I am carrying.
>
>  What issues are still open.  I was under the belief that Zhang had
>  resolved all the issues.
>

The high priority review item is that the driver performs operation
completion callbacks in hardirq context.  Clients of the API assume
that callbacks will happen in softirq context.  Of lesser concern is
the use of GFP_ATOMIC in fsl_dma_alloc_descriptor.  Other drivers
preallocate a small pool of descriptors.

Regards,
Dan
