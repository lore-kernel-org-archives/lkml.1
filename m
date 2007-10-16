Return-Path: <linux-kernel-owner+w=401wt.eu-S936294AbXJPWDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936294AbXJPWDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935529AbXJPWDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:03:21 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:41058 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935451AbXJPWDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:03:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DVNth23lqxSKQyR4tLu3O7Tmxqhf8IitEzm1P/tvy+rRxjTf984uJYxS/nBTW27gBA2Xj16O9B3rIgk2466ItLwP9kXHjYmRgNtETdSlqenIXuA+R+TIlksKDvmLQ7Ap8ws77fMonRHXTHdMlzt21Em/hrRtovj34f0K8gl+nf0=  ;
X-YMail-OSG: VvnV0DwVM1n_6JL_bxof6zuPDdPYtUyQoflBpTknrSQZI3_OccI0RbfSF.B_T5AnHBDTo3V0aA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch][rfc] rewrite ramdisk
Date: Wed, 17 Oct 2007 08:08:30 +1000
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710161747.12968.nickpiggin@yahoo.com.au> <20071016212853.GB1314@closure.lan>
In-Reply-To: <20071016212853.GB1314@closure.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170808.30944.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007 07:28, Theodore Tso wrote:
> On Tue, Oct 16, 2007 at 05:47:12PM +1000, Nick Piggin wrote:
> > +	/*
> > +	 * ram device BLKFLSBUF has special semantics, we want to actually
> > +	 * release and destroy the ramdisk data.
> > +	 */
>
> We won't be able to fix completely this for a while time, but the fact
> that BLKFLSBUF has special semantics has always been a major wart.
> Could we perhaps create a new ioctl, say RAMDISKDESTORY, and add a
> deperecation printk for BLKFLSBUF when passed to the ramdisk?  I doubt
> there are many tools that actually take advantage of this wierd aspect
> of ramdisks, so hopefully it's something we could remove in a 18
> months or so...

It would be nice to be able to do that, I agree. The new ramdisk
code will be able to flush the buffer cache and destroy its data
separately, so it can actually be implemented.
