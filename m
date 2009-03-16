Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZCPTpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZCPTpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZCPTpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:45:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:27726 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZCPTpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A9FfwWUgf49zYnB0i1ifMceDlmr3B7px+DYnDY49qr5iFd5pHjiMQQoQ3dujd+Nw+d
         bFCw6ARDJvre0fKByFfM678djD8o24iyERg8uLuOrtt9TQHAPBIiEWhQuyzMM4u90DBs
         t7d6cmDEmEAopIR8zdz/4/J0jFGcTZ57yr1PI=
MIME-Version: 1.0
In-Reply-To: <20090312092114.GC6949@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz>
Date: Mon, 16 Mar 2009 15:45:36 -0400
Message-ID: <87f94c370903161245u727090a7m93735d1b57971d9f@mail.gmail.com>
Subject: Re: ext2/3: document conditions when reliable operation is possible
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, tytso@mit.edu, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 5:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
<snip>
> +Sector writes are atomic (ATOMIC-SECTORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.
> +
> +       Unfortuantely, none of the cheap USB/SD flash cards I seen do
> +       behave like this, and are unsuitable for all linux filesystems
> +       I know.
> +
> +               An inherent problem with using flash as a normal block
> +               device is that the flash erase size is bigger than
> +               most filesystem sector sizes.  So when you request a
> +               write, it may erase and rewrite the next 64k, 128k, or
> +               even a couple megabytes on the really _big_ ones.
> +
> +               If you lose power in the middle of that, filesystem
> +               won't notice that data in the "sectors" _around_ the
> +               one your were trying to write to got trashed.

I had *assumed* that SSDs worked like:

1) write request comes in
2) new unused erase block area marked to hold the new data
3) updated data written to the previously unused erase block
4) mapping updated to replace the old erase block with the new one

If it were done that way, a failure in the middle would just leave the
SSD with the old data in it.

If it is not done that way, then I can see your issue.  (I love the
potential performance of SSDs, but I'm beginning to hate the
implementations and spec writing.)

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
