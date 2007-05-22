Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbXEVDHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbXEVDHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 23:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbXEVDHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 23:07:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37501 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbXEVDHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 23:07:42 -0400
Date: Tue, 22 May 2007 08:43:27 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Shaya Potter <spotter@cs.columbia.edu>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted filesystems
Message-ID: <20070522031327.GA4728@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com> <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr> <20070518111042.GC4869@in.ibm.com> <464DAE73.7000302@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464DAE73.7000302@cs.columbia.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 09:47:31AM -0400, Shaya Potter wrote:
> Bharata B Rao wrote:
> 
> >
> >Not really. This is called during copyup of a file residing in a lower
> >layer. And that is done only for regular files.
> 
> That is broken.

But it only breaks the semantics (in other cases we allow writes only to the
top layer files). So the question is why do we have to copy up the device
node ? What difference it makes to writing to the device itself ? Currently
we allow write to the device using the lower layer device node itself.

> 
> You should be able to change the permissions on a device node on a layer 
> that is RO.
> 

Hmm not sure why we need to touch the permissions of the device. See below.

> so it would copy it up (1. mknod, 2. copy attributes) and then the 
> appropriate attribute notification change would be called.

With union mount, when a regular file is opened for write, it is checked
if it resides in the lower layer and if so copied up to the topmost layer
and this new fd is returned from open. And any subsequent writes using this
fd will go to the newly created topmost file. (We are aware that we are not
yet copying the (extended) attributes to the newly created topmost file,
which we have to do).

Regards,
Bharata.
