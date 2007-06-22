Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbXFVMTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbXFVMTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXFVMTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:19:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:11057 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXFVMTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l0Ori7D33bt0aqvEuBv5mXbOsJIMtLfegQ4eNlcWCJfQZcSO/jjCs3DphSDphejZkCB1+dG87LLae5sLmUanPj8cdiHBsSpoDjJ0g0WHIIaF2PqGMTIKYBtnqvfD6VNOIIx29f6XAWSeqHWm7kTBPmzsgxgHTDpO3qaby2/cA38=
Message-ID: <a781481a0706220519y1d6c8044mac19d4da9dfc3df2@mail.gmail.com>
Date: Fri, 22 Jun 2007 17:49:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [BUG?]Set XIP mount option on ext2 bypass check.
Cc: "Carsten Otte" <cotte@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Yan Zheng" <yanzheng@21cn.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706220122.41586.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4679A58C.2080008@21cn.com> <467A5E36.9030904@de.ibm.com>
	 <1182431869.7145.7.camel@cotte.boeblingen.de.ibm.com>
	 <200706220122.41586.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/22/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 21 June 2007, Carsten Otte wrote:
> >
> > This is an updated version of my bugfix patch. Yan Zheng pointed out,
> > that ext2_remount lacks checking if -o xip should be enabled or not.
> > This patch checks for presence of direct_access on the backing block
> > device and if the blocksize meets the requirements.
> > Andrew, please consider adding this patch to -mm.
> >
> > Signed-off-by: Carsten Otte <cotte@de.ibm.com>
>
> It looks to me like a local denial of service attack in case of
> user-mountable ext2 file systems in /etc/fstab.
>
> Shouldn't that make it go into 2.6.22?

I agree. I would go on to suggest that all trivially-triggered oopsen /
panics from userspace (even if they require privileges, such as the
cat /dev/snapshot == oops issue posted last week) in fact ought to
be CVE's, and the corresponding fixes for such issues be considered
as candidates for -stable, if applicable to the current stable kernel.

Satyam
