Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0CEGBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:01:11 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60451 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0CEGBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vdNYvMNhQ/ZH6DgiwOrKUImK2+mo0gG3m7wxsVqseaTaYiXQlWhTljsO5tjmxPLLWS
         wv391HxG5mxFPpQOWWUUl+yNb0ORphnYc5KkwUE5pf5Ek7qKrxTueza3MWQ8yWkU8bRE
         0B+Q1PpBoGFM2WUreTUKxBRqC7LCwxo/FUsKw=
MIME-Version: 1.0
In-Reply-To: <201003050042.o250gsUC007947@alien.loup.net>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	 <f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
	 <201003041631.o24GVl51005720@alien.loup.net>
	 <f875e2fe1003041012m680ffc87i50099ed011526440@mail.gmail.com>
	 <201003050042.o250gsUC007947@alien.loup.net>
Date: Fri, 5 Mar 2010 01:01:07 -0500
Message-ID: <87f94c371003042201n72ce8578vc01331678b52da75@mail.gmail.com>
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Mike Hayward <hayward@loup.net>
Cc: foosaa@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please let me know if you can prove data corruption.  I'm writing a
> sophisticated storage app and would like to know if kernel has such a
> defect.  My bet is it's just a drive that is slowly remapping.
>
> - Mike

For clarity, most ATA class disk drives are spec'ed to have one
non-recoverable error per 150TB or so of writes.  Disk drives do blind
writes.  (ie. They are not verified).  So we should all expect to have
the occasional silent data corruption on write.  The problem is
compounded with bad cables, controllers, RAM, etc.

The only way for the linux kernel even attempt to fix that is for it
to do a read verify on everything it writes.  For the vast majority of
uses that is just not acceptable for performance reasons.

OTOH, if data integrity is of the utmost for you, then you should
maintain a md5hash or similar for your critical files and verify them
any time you make a copy.  btrfs may offer a auto read-verify.  I
don't know much about btrfs.

Greg


-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
