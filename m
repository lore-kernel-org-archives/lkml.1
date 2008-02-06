Return-Path: <linux-kernel-owner+w=401wt.eu-S1763398AbYBFMRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763398AbYBFMRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbYBFMQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:16:50 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:46694 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762257AbYBFMQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x8nd+ry1b9ncOcTBt7phLnPCDlmPPzCg2ZNvc1LWvzRBJTuVrLLIrYCisvXbHltAvh9J7UFAlHWX7qUw3QUKDVsTqzNQidet3bT2quqf9irgHmDouazGLAX156m9wbuqdRAcAo7lhNhhvna5YaGn3g6iV11hyHWn9Iop75B72po=
Message-ID: <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
Date: Wed, 6 Feb 2008 13:16:43 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Erez Zilber" <erezz@voltaire.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47A89660.1080804@Voltaire.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <47A89660.1080804@Voltaire.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 6:01 PM, Erez Zilber <erezz@voltaire.com> wrote:
>
> Using such large values for FirstBurstLength will give you poor
> performance numbers for WRITE commands (with iSER). FirstBurstLength
> means how much data should you send as unsolicited data (i.e. without
> RDMA). It means that your WRITE commands were sent without RDMA.

Sorry, but I'm afraid you got this wrong. When the iSER transport is
used instead of TCP, all data is sent via RDMA, including unsolicited
data. If you have look at the iSER implementation in the Linux kernel
(source files under drivers/infiniband/ulp/iser), you will see that
all data is transferred via RDMA and not via TCP/IP.

Bart Van Assche.
