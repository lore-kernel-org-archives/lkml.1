Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYEZTYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYEZTYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYEZTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:23:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33106 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbYEZTXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FlXzirdIAS3t2xzdLeCwEf4Egdal3D0XlXu4lafuH86fiJ5TB+nGpsrYf1w4oGioyAfKkKmjSISC5bJ84pHsu5l+ZBdxoFAB0VzQhktpp7ToAHQLyS6ECllPNrqo02I6dSEfQBB/OHoUxof8K8VZy0D6zVFBfoQkRuUkMxOfO2o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 14/40] ide-floppy: merge idefloppy_transfer_pc() and idefloppy_transfer_pc1()
Date: Tue, 27 May 2008 20:57:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185633.5636.61364.sendpatchset@localhost.localdomain> <20080521052429.GA2414@gollum.tnic>
In-Reply-To: <20080521052429.GA2414@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805272057.42444.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Borislav Petkov wrote:
> On Sun, May 18, 2008 at 08:56:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > * Check IDEFLOPPY_FLAG_ZIP_DRIVE flag in idefloppy_transfer_pc1()
> >   and skip idefloppy_transfer_pc2()-phase if the flag is not set.
> > 
> > * Always use idefloppy_transfer_pc1() in idefloppy_issue_pc()
> >   and remove no longer needed idefloppy_transfer_pc().
> 
> ... and also probably mv idefloppy_transfer_pc1() to something like
> idefloppy_start_transfer_pc() and rename idefloppy_transfer_pc2() to something
> more appropriate like e.g. idefloppy_do_transfer_pc() or similar and do away
> with those misleading names and probably even the comments are superfluous then.

Probably the most intuitive would be to do:

	idefloppy_transfer_pc1() -> idefloppy_transfer_pc()

and

	idefloppy_transfer_pc2() -> idefloppy_do_transfer_pc()

but I don't feel too strong about it and welcome other ideas
(preferably in form of patches :).

Thanks,
Bart
