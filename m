Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYCUWFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYCUWFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYCUWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:05:47 -0400
Received: from mail.tuxonice.net ([67.207.135.122]:58347 "EHLO
	mail.tuxonice.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYCUWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:05:47 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <Pine.LNX.4.44L0.0803202049550.11234-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0803202049550.11234-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 09:05:47 +1100
Message-Id: <1206137147.30885.6.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2008-03-20 at 20:52 -0400, Alan Stern wrote:
> For an S5 hibernation, the interpreter state within the image is wrong.  
> The image kernel needs to have the interpreter state from the boot 
> kernel -- I don't know if this is possible.

It's possible.

1) When hibernating, allocate a page (or pages if one isn't enough) for
the data to end up in after the atomic restore.
2) Put the location(s) in the image header.
3) At resume time, allocate an equivalent number of extra 'safe' pages
and set up extra pbes for the atomic restore to copy data from the extra
pages to the ones allocated when hibernating.
4) At the appropriate point in time, copy the NVS data to the extra
'safe' pages allocated in step 3.

The data will then be available to the resumed kernel post-resume.

I've been using this method to pass data from the boot kernel to the
resumed kernel for a while now. (I'm using it for I/O speed statistics
and state preservation).

Regards,

Nigel

