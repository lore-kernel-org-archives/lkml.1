Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXEVMqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXEVMqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXEVMqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:46:12 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:52169 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbXEVMqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:46:11 -0400
Message-ID: <4652E385.30803@cs.columbia.edu>
Date: Tue, 22 May 2007 08:35:17 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted
 filesystems
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com> <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr> <20070518111042.GC4869@in.ibm.com> <464DAE73.7000302@cs.columbia.edu> <20070522031327.GA4728@in.ibm.com> <Pine.LNX.4.61.0705220824320.4452@yvahk01.tjqt.qr> <20070522083826.GD4728@in.ibm.com>
In-Reply-To: <20070522083826.GD4728@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Tue, May 22, 2007 at 08:25:16AM +0200, Jan Engelhardt wrote:
>> On May 22 2007 08:43, Bharata B Rao wrote:
>>> On Fri, May 18, 2007 at 09:47:31AM -0400, Shaya Potter wrote:
>>>> Bharata B Rao wrote:
>>>>
>>>>> Not really. This is called during copyup of a file residing in a lower
>>>>> layer. And that is done only for regular files.
>>>> That is broken.
>>> But it only breaks the semantics (in other cases we allow writes only to the
>>> top layer files). So the question is why do we have to copy up the device
>>> node ? What difference it makes to writing to the device itself ?
>> Because `chmod 666 blockdevnode` is not the same as writing
>> to the device itself?
> 
> What if that chmod is applied on the lower level device node ? This is what
> we do currently, even for regular files. Copyup happens only when the file
> is opened for writing.
> 
> Let me rephrase my earlier question:
> 
> In case of regular files, when we copyup a file, we are actually preventing
> any writes to the lower layers (which we have designated as read only).
> 
> Applying the same logic to devices, what do we achieve by copying them up ?
> How does it matter if we write to the device through a node in the upper
> layer or in the lower layer. Both the writes eventually do the same thing.

What happens if the lower layer is on a read only medium.  But the top 
layer is RW.  Why can't one change permissions?  In your model, one can't.

What happens if one wants to share a lower layer read-only (I'm doing 
this with my research into uses of union file systems), one doesn't want 
permission change in one use of the lower layer to affect any of the 
other uses.


> What I am trying to understand is, if the need for copyup is purely a matter
> of conforming to semantics (of not allowing writes to the lower layers in
> case of union mount) or do we achieve anything else by doing a device
> copyup ? Are there any cases where copying up of device nodes are absolutely
> essential for sane behaviour ?

If the lower layer is relatively immutable (ignoring atime) it can be 
shared in a RO manner by multiple unions.  If it's not, it can't be. 
Also, copyup is needed in general as the RO union layer can be on a RO 
file system but the union will not be RO.
