Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYDDEXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYDDEXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 00:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYDDEW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 00:22:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22150 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYDDEW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 00:22:58 -0400
Date: Thu, 03 Apr 2008 22:20:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Access to struct file in scsi_request_fn()?
In-reply-to: <cffffbd9-8d29-4c23-a7f9-315d1d519ed6@d45g2000hsc.googlegroups.com>
To: "hectorlas@yahoo.com" <hectorlas@yahoo.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47F5AC92.2050003@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <cffffbd9-8d29-4c23-a7f9-315d1d519ed6@d45g2000hsc.googlegroups.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hectorlas@yahoo.com wrote:
> Here's the short question:  Is there a way to access the struct file
> associated with a write() within the libATA code?
> 
> I've been documenting the semi-direct execution path from a file I/O
> open() call down to the ata_scsi_rw_xlat() call in libATA.  I'd like
> to modify my local libATA code to do something based on the file being
> operated on using a flag that I still need to store in struct file,
> perhaps through the private_data field (I haven't worked that out
> yet).  The scsi_request_fn() gets a struct request_queue argument that
> has a lot of contexts in it.  Could anyone help me with information on
> whether the struct file * is in it somewhere?  I know there's some
> kind of cohesion between submitting the scsi command and its
> completion function, but I'm not quite seeing it yet.
> 
> That was painful to write, I'm sure it was painful to read, sorry
> about that.  I'm learning more and more as I go, but the big picture
> is still escaping me.
> 
> Thanks.
> Hector

I think that this is likely not a good approach for whatever you're 
attempting to do (and you would likely get better responses if you 
described what exactly that is). By the time libata or even the SCSI 
layer gets a write request, that is pretty well removed from the 
original file operation. They may be quite highly separated in time due 
to write buffering for one thing.
