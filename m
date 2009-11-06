Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZKFIAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZKFIAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZKFIAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:00:47 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:59333 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZKFIAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:00:47 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Fri, 6 Nov 2009 09:00:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-self-00026-g91d3f9b; KDE/4.3.2; i686; ; )
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@linux-foundation.org,
       "Michael S. Tsirkin" <mst@redhat.com>
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <1257266319-24300-2-git-send-email-amit.shah@redhat.com> <200911061740.03734.rusty@rustcorp.com.au>
In-Reply-To: <200911061740.03734.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911060900.49923.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 06 November 2009 08:10:02 schrieb Rusty Russell:
> On Wed, 4 Nov 2009 03:08:39 am Amit Shah wrote:
> > Expose multiple char devices ("ports") for simple communication
> > between the host userspace and guest.
> 
> OK, I've taken the chance to audit this patch.  I started adding patches
> until I got overwhelmed.   It's a complete mess and needs a total rewrite
>  :(

I know that Anthony disagrees, but _If we start over_, I still think we should 
use that chance and leave the old virtio console untouched and add a new driver 
for the host guest communication. IMHO it turned out that there is only a tiny 
bit of commonality. (most code pathes check for use_multiport and  then do two 
completely different things).
I like simplicity. According to David A. Wheeler's SLOCCount, the old console 
has 141 lines of code and the I truly believe that a separate guest-host comm 
vehicle would also be a lot simpler if it must not take care of the old 
virtio_console interface.

On the other hand we all should agree on one driver vs. two drivers before we go 
on. Everything else would be unfair to Amit, who had the unpleasant task to 
implement conflicting review comments....

Christian
