Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYFWUea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYFWUea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYFWUeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:34:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYFWUeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:34:21 -0400
Message-ID: <486008C1.8000207@redhat.com>
Date: Mon, 23 Jun 2008 15:34:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andreas Dilger <adilger@sun.com>
CC: FD Cami <francois.cami@free.fr>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
References: <20080622201841.669ff882@olorin> <20080623203107.GD6239@webber.adilger.int>
In-Reply-To: <20080623203107.GD6239@webber.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Jun 22, 2008  20:18 +0200, FD Cami wrote:
>> This patch takes a shot at replacing the direct use of printk(KERN_WARNING)
>> in extX by extX_warning. We now get the device number in the warning message :
>> "EXT3-fs warning (device hda1): ext3_setup_super: maximal mount count reached, running e2fsck is recommended"
>> It also adds the device information on a pair of printk(KERN_ERR) (this was
>> first suggested by Kasper two weeks ago).
> 
> The one issue is that KERN_ERR != KERN_WARNING, so these errors might
> not be visible on the console, or may not be saved to the syslog.  The
> other minor difference is that the function name is also printed, and this
> makes the error message very long.
> 
> One suggestion is to create a separate macro that passes the KERN_*
> flag and __func__ to ext3_console_msg(), and call that from
> ext3_warning() and a new ext3_start_error() function.  I always found
> it annoying to have to specify __func__ as a parameter for every call.

I agree and meant to suggest that as well.

-Eric
