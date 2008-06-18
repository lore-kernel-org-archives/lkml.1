Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYFRRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYFRRaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYFRRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:30:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:19361 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYFRRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=oK7FoA1eZLDVxbA/0FXhtc3yhzg1pOdnSd0POIA/3CXWbAsx2yHm1R+jyS8H9G7SFc
         dOW9SNJG2WSo1sa/Zr2OP/3SEHOs21717U3ub0HyihiFeflb+JJAS2pqOj+fHebupBRo
         wblNp7EZRBF9ON4odNlFVffnaCW9E0fwSeV3s=
Message-ID: <4859461A.7060003@panasas.com>
Date: Wed, 18 Jun 2008 20:30:02 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Request for discussion on when to merge drivers
References: <1213802866.3515.24.camel@localhost.localdomain>
In-Reply-To: <1213802866.3515.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun. 18, 2008, 18:27 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> There have been a large number of emails on lkml (too many for me to
> dredge up and quote) plus a fair few private ones on the subject of when
> to merge drivers.  The opinions seem to vary from "immediately they show
> up on the mailing list" to " after we're sure they're demonstrated to be
> working and maintainable".  The fact that the arguments have been going
> round and round on the various mailing lists without generating any
> consensus would seem to indicate the topic would benefit from some face
> to face discussion time.
> 
> I think the Kernel Summit would be a good place to have a discussion of
> what the criteria are for merging a driver (even if, in the end, it's at
> the discretion of the subsystem maintainers).
> 
> I think everyone agrees that we can't put just anything that appears on
> the mailing list in the tree, since they all have to be at least code
> inspected and be checked for the usual errors, omissions and root holes.
> However, disagreements seem to set in after this.
> 
> For the record, my own view is that when a new driver does appear we
> have a limited time to get the author to make any necessary changes, so
> I try to get it reviewed and most of the major issues elucidated as soon
> as possible.  However, since the only leverage I have is inclusion, I
> tend to hold it out of tree until the problems are sorted out.
> Experience has shown that for most SCSI drivers, the authors tend to be
> the people producing the hardware and without documentation, no-one else
> can fix up anything other than obvious coding errors, so we can't put it
> in the tree and hope someone else will fix it if they have a problem.
> 
> One possible way of doing this is certainly to put the drivers in the
> staging tree:
> 
> http://marc.info/?l=linux-kernel&m=121312896923196
> 
> The only slight wrinkle (at least for me) is that often the process of
> cleaning up a driver is fairly intensive for a maintainer and turn
> around is a lot faster if you're doing it in a tree you control.  (All
> the scsi drivers we've done like this have lived in temporary branches
> while they were being worked on).  So perhaps in addition we should be
> encouraging maintainers to run staging branches under similar rules in
> the staging tree, but allowing inclusion into linux-next?

This is a very good idea.

Exposing the not-yet-ready-to-be-released code to linux-next will
expose conflicts earlier, and hopefully in smaller, more manageable
deltas.

However, some projects that need staging may change kernel APIs
to such extent that including them in linux-next will require
committing to the API changes in the -next time frame.  If that's
a problem, staging them in the maintainer's tree may still be valuable.

Benny

> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

