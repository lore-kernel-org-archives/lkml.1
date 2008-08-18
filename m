Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYHRVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYHRVLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYHRVLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:11:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:10101 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYHRVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=jW5vgt89+C29vr2ZDei/7F5leFFfTuATw1DRJv8ASMjm70Pt5WikZFe3v0Sf0cf1/C
         U5hkaGaPVTZRvX+1xQPIgKzzENWNmbzF92PfUdEBXcOXkwqlPeXOPWXiUzXKK7f9e/mp
         n0gwZ7EwAJixB6hTdo+Wj31m9kzPpDTwkse5w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/5] ide debugging macros
Date: Mon, 18 Aug 2008 23:08:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808182308.38345.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 17 August 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's something i've been wanting to do for a long time: debugging macros. The
> reason for it is that i got tired of adding debug printk's everytime i'm testing
> something so here we go.
> 
> The debugging macro is similar to the old ones but is one for all drivers
> (currently only ide-floppy), is nice on branch prediction and is controlled by a
> drive->debug_mask switch which is a module parameter and as such can be set at
> module load time, of course. I've been thinking of adding also a sysfs attribute
> too but can't seem to find quite the justification for it so no sysfs for now :)

if you look closely you should already find it :)

[ module parameters are exported through sysfs and it uses 0644 mask ]

> In addition, one can still optimize away all the debug calls in the old manner
> and i'm sure those will be removed completely too when ide generic conversion is
> done.
> 
> Please tell me what you think, what can be changed/improved and after we've
> figured out the details I'll do the other drivers too.

Looks pretty good to me (after quick look) and I applied to pata tree.

PS I wonder whether we may also want to have global debug_mask for core code
messages ('drive' is not always available) in the longer-term.  Or maybe even
only global debug_mask for both core code and driver messages?

Thanks,
Bart
