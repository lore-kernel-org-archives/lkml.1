Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYGVGL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYGVGL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 02:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYGVGLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 02:11:50 -0400
Received: from li26-190.members.linode.com ([67.18.89.190]:36579 "EHLO
	notebook.homenet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbYGVGLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 02:11:49 -0400
Date: Tue, 22 Jul 2008 08:11:47 +0200
From: Tomas Styblo <tripie@cpan.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
	device 152d:2338
Message-ID: <20080722061147.GB8303@notebook.homenet.local>
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no> <4884E585.2050104@shaw.ca> <20080722051110.GA8303@notebook.homenet.local> <488570A5.8000602@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488570A5.8000602@shaw.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Hancock <hancockr@shaw.ca> [Tue, 22 Jul 2008]:
>
> In any case, given that your code apparently fixes the corruption it seems 
> that srb->result is being set to SAM_STAT_CHECK_CONDITION, but the 
> DID_ERROR and SUGGEST_RETRY flags are not being set. Presumably then the  
> SCSI layer looks at the sense data and says "hmm, nothing to worry about 
> here" and carries on.

That's exactly what I thought was happening, after a cursory 
look at the SCSI code.

>
> I think we do need something like your patch, though it should likely be 
> moved inside the if (need_auto_sense) check, and I don't see a reason to 
> limit to this device ID only.

Thank you. This is a very insidious bug as it doesn't manifest
itself very often, months of data corruption may pass before you
notice it.

So is there a bug in the chipset, or does the error handling code 
not follow specifications?

I wonder if the company that makes the chipset should be notified
about this problem?


-- 
Tomas Styblo <tripie@cpan.org>
