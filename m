Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbXEVIgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbXEVIgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEVIf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:35:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51961 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbXEVIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:35:54 -0400
Date: Tue, 22 May 2007 14:08:26 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Shaya Potter <spotter@cs.columbia.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted filesystems
Message-ID: <20070522083826.GD4728@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com> <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr> <20070518111042.GC4869@in.ibm.com> <464DAE73.7000302@cs.columbia.edu> <20070522031327.GA4728@in.ibm.com> <Pine.LNX.4.61.0705220824320.4452@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705220824320.4452@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:25:16AM +0200, Jan Engelhardt wrote:
> 
> On May 22 2007 08:43, Bharata B Rao wrote:
> >On Fri, May 18, 2007 at 09:47:31AM -0400, Shaya Potter wrote:
> >> Bharata B Rao wrote:
> >> 
> >> >
> >> >Not really. This is called during copyup of a file residing in a lower
> >> >layer. And that is done only for regular files.
> >> 
> >> That is broken.
> >
> >But it only breaks the semantics (in other cases we allow writes only to the
> >top layer files). So the question is why do we have to copy up the device
> >node ? What difference it makes to writing to the device itself ?
> 
> Because `chmod 666 blockdevnode` is not the same as writing
> to the device itself?

What if that chmod is applied on the lower level device node ? This is what
we do currently, even for regular files. Copyup happens only when the file
is opened for writing.

Let me rephrase my earlier question:

In case of regular files, when we copyup a file, we are actually preventing
any writes to the lower layers (which we have designated as read only).

Applying the same logic to devices, what do we achieve by copying them up ?
How does it matter if we write to the device through a node in the upper
layer or in the lower layer. Both the writes eventually do the same thing.

What I am trying to understand is, if the need for copyup is purely a matter
of conforming to semantics (of not allowing writes to the lower layers in
case of union mount) or do we achieve anything else by doing a device
copyup ? Are there any cases where copying up of device nodes are absolutely
essential for sane behaviour ?

Regards,
Bharata.
