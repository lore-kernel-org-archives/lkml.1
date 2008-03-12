Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYCLVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYCLVyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYCLVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:54:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYCLVyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:54:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Wed, 12 Mar 2008 22:53:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122253.07631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Alan Stern wrote:
> On Wed, 12 Mar 2008, Huang, Ying wrote:
> 
> > I think "kexec based hibernation" is the only currently available
> > possible method to write out image without freezer (after driver works
> > are done). If other process is running, how to prevent them from writing
> > to disk without freezing them in current implementation?
> 
> This is a very good question.
> 
> It's a matter of managing the block layer's request queues.  Somehow 
> the existing I/O requests must remain blocked while the requests needed 
> for writing the image must be allowed to proceed.
> 
> I don't know what would be needed to make this work, but it ought to be 
> possible somehow...

Yes, it ought to be possible.

Ultimately, IMHO, we should put all devices unnecessary for saving the image
(and doing some eye-candy work) into low power states before the image is
created and keep them in low power states until the system is eventually
powered off.

If this is done, the remaining problem is the handling of the devices that we
need to save the image.  I believe that will be achievable without using the
freezer.

Thanks,
Rafael
