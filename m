Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYK0TgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYK0TgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 14:36:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYK0Tfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 14:35:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:15451 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYK0Tfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 14:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UKbr5uqXzbsGmO9rtoIvA5K9rzDOt0Io7wnv9tLVOT8qThgwrVTEykToTObuAcs/se
         8ZfKUeZKWPpnxxDtNXIvy43uGyOZUXH6op5ZtDXWMcSC6fKj3cC9S58WAtss0JMKkFDc
         YC+FNNAcWD67L+mS2fmkzGGZWLdBgmmvU5jiw=
Subject: Re: [PATCH-mm 1/8] ntfs: remove private wrapper around endian
 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <B9FA83C0-9993-44BB-86AA-FA8B97A2D6A2@cam.ac.uk>
References: <1227733970.5511.123.camel@brick>
	 <B9FA83C0-9993-44BB-86AA-FA8B97A2D6A2@cam.ac.uk>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 11:35:44 -0800
Message-Id: <1227814545.5511.143.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 08:22 +0000, Anton Altaparmakov wrote:
> Hi,
> 
> On 26 Nov 2008, at 21:12, Harvey Harrison wrote:
> > The base versions handle constant folding just fine.
> > Done with sed other than the mft.c and inode.c one-liners.
> 
> Have you checked the compiler output?  And on all architectures?  And  
> on all gcc versions?

Yes I've checked the compiler output for the new byteorder helpers
for gcc 3.4, 4, 4.2 on x86.

Notice this depends on the byteorder bits in -mm.  The failure of
the old bits to properly compile-time swap I've only seen at -O0,
which the new bits do properly.  If you can cite a particular
version/arch that you know of where the bug arose, please let me
know.

> 
> The reason I introduced the constant version are precisely that at  
> least some versions of gcc at least on some architectures do NOT  
> handle the constant folding and actually put in endianness conversion  
> code for the constants instead of converting them at compile time.

Which ones....-O0 builds perhaps?

> 
> Also you are breaking sparse checking with this patch as you remove  
> some of the necessary endianness conversions (e.g. your one liner in  
> mft.c which causes us to apply a binary 'not' operator on a little  
> endian which sparse complains about - in fact that is the reason the  
> endianness conversions are in there in the first place - I added them  
> because sparse was complaining about them).

No, sparse does not complain about it.  Bitwise operations are just
fine on types such as le16 etc.  Try running sparse again with
my changes, there are no new warnings.

> 
> Andrew, please do not apply this patch.
> 

I hope you change you mind.

Harvey

