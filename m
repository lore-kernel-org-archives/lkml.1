Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXAWBoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXAWBoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXAWBoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:44:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:47135 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbXAWBoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YyPyqkif8t9RDwskczse5LiMPC6QKh4KCunEEhev/m5UCY6L5HrffWLTZehiTS+g+69dBURTq5ETIaxomAk3IZaO/Z7eLSL6b7LTpIht17I1Lz5JK1bBBf98/M1UmgCo8w1SlEo0m3bpFLmYGIZD6/+3fGqcNwCg+FIN+cNCeM4=
Message-ID: <e9c3a7c20701221744i7f0de470r4c8183dd3bcd20b5@mail.gmail.com>
Date: Mon, 22 Jan 2007 18:44:11 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <17845.13256.284461.992275@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	 <45B5261B.1050104@redhat.com>
	 <17845.13256.284461.992275@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/07, Neil Brown <neilb@suse.de> wrote:
> On Monday January 22, cebbert@redhat.com wrote:
> > Justin Piszcz wrote:
> > > My .config is attached, please let me know if any other information is
> > > needed and please CC (lkml) as I am not on the list, thanks!
> > >
> > > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to
> > > the RAID5 running XFS.
> > >
> > > Any idea what happened here?
> ....
> > >
> > Without digging too deeply, I'd say you've hit the same bug Sami Farin
> > and others
> > have reported starting with 2.6.19: pages mapped with kmap_atomic()
> > become unmapped
> > during memcpy() or similar operations.  Try disabling preempt -- that
> > seems to be the
> > common factor.
>
> That is exactly the conclusion I had just come to (a kmap_atomic page
> must be being unmapped during memcpy).  I wasn't aware that others had
> reported it - thanks for that.
>
> Turning off CONFIG_PREEMPT certainly seems like a good idea.
>
Coming from an ARM background I am not yet versed in the inner
workings of kmap_atomic, but if you have time for a question I am
curious as to why spin_lock(&sh->lock)  is not sufficient pre-emption
protection for copy_data() in this case?

> NeilBrown

Regards,
Dan
