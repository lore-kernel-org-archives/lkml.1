Return-Path: <linux-kernel-owner+w=401wt.eu-S937177AbXFGVnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937177AbXFGVnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935911AbXFGVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:43:35 -0400
Received: from rtr.ca ([64.26.128.89]:2758 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765055AbXFGVne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:43:34 -0400
Message-ID: <46687C05.1080408@rtr.ca>
Date: Thu, 07 Jun 2007 17:43:33 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682E4E.1070303@redhat.com>
In-Reply-To: <46682E4E.1070303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 06/07/2007 11:41 AM, Andrew Morton wrote:
>>>    mount /var/lib/mythtv -oremount,ro
>>>    sync
>>>    umount /var/lib/mythtv
>> Did this succeed?  If the application is still truncating that file, the
>> umount should have failed.
> 
> Shouldn't sync should wait for truncate to finish?

The part that gets me here, and that others might be missing,
is that we are not waiting for ftruncate at this point.

We're waiting for unlink.  The application that was doing ftruncate
in tiny little doses has been sent a kill-9 signal, so what should
be happening now (confirmed by disk activity LEDs) is the file should
just be getting deleted the same as if we did "rm bigfile" on it.

And I kind of expected sync or remount,ro to complete *after* the
unlink finishes..

Oh well.
