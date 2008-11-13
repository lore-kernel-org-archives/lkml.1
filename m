Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKMRc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKMRc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYKMRcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:32:17 -0500
Received: from kroah.org ([198.145.64.141]:53584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbYKMRcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:32:17 -0500
Date: Thu, 13 Nov 2008 09:31:27 -0800
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Store the relevant miscdevice in file->private_data in
	misc_open()
Message-ID: <20081113173127.GB30811@kroah.com>
References: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 03:49:50PM +1100, Michael Ellerman wrote:
> Currently it's not easy to share file_operations between multiple
> instances of a miscdevice. In order to do this, the device code needs to
> store a list of all it's miscdevice instances, and when fops->open() is
> called, search the list and find the right device based on the minor
> number.
> 
> However the generic miscdevice code already has a list of miscdevices,
> and uses this to find the right device in misc_open(). If misc_open()
> would store the miscdevice it found in file->private_data, then the
> device code wouldn't need to worry about storing it's own separate list
> and searching that as well.
> 
> The rest of the miscdevice code does not use file->private_data, so the
> device code is still free to use file->private_data for something else
> if it wants to.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Do you have a follow-on patch for some misc device using code that would
take advantage of this change?

thanks,

greg k-h
