Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524Ab0AZEqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0AZEqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485Ab0AZEqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:46:44 -0500
Received: from kroah.org ([198.145.64.141]:48626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab0AZEqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:46:44 -0500
Date: Mon, 25 Jan 2010 20:36:46 -0800
From: Greg KH <greg@kroah.com>
To: Himanshu Chauhan <himanshu@symmetricore.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>
Subject: Re: sysfs_ops show vector: size of buffer not required?
Message-ID: <20100126043646.GB32066@kroah.com>
References: <20100124074118.GA4201@himanshu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100124074118.GA4201@himanshu-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 01:11:18PM +0530, Himanshu Chauhan wrote:
> Hi All,
> 
> The sysfs_ops's show vector doesn't have a size of the
> buffer given to the vector, while store on the other hand
> has. What is the rationale behind it?

If you need to check the size, you are doing something wrong.

Seriously, that is the reason.  A sysfs file should be a single value,
which will never overflow the buffer.

> I see most of the implementations doing strcpy in the
> show vectors. Ill behaved driver might overwrite the
> given buffer when size is not known. Should this be addressed
> by providing the buffer size along with the buffer pointer?

Nope.

Again, a single value only, it easily fits into the buffer size.

thanks,

greg k-h
