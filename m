Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZBSEFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZBSEFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZBSEEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:04:52 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:19171 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZBSEEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:04:51 -0500
MIME-Version: 1.0
In-Reply-To: <200902161621.28142.oliver@neukum.org>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
	 <200902160931.34771.oliver@neukum.org>
	 <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
	 <200902161621.28142.oliver@neukum.org>
Date: Wed, 18 Feb 2009 23:04:48 -0500
X-Google-Sender-Auth: d54812ece458ac20
Message-ID: <5aa163d00902182004v1ad42498w9fbe5a74bf5f41d2@mail.gmail.com>
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 10:21 AM, Oliver Neukum <oliver@neukum.org> wrote:
>> tests seemed to verify this claim... as sending LED commands
>> GFP_KERNEL while holding the mutex resulted in BUGs (scheduling while
>> atomic) in dmesg. Switching those GFP_KERNELs to GFP_ATOMICs
>> eliminated that particular BUG.
>
> Please post that BUG.
>

I switched back to GFP_KERNEL on the functions in question.

After further testing, I have determined that the BUG only occurs on
my Ubuntu (2.6.27) system, and only when using the rumble function. I
am unable to reproduce the BUG on my Arch (2.6.28) system, so it is
either an artifact of some patch to this kernel, or it got fixed
somewhere between 2.6.27 and 2.6.28.

Based on this analysis, and (more importantly) an inability to
reproduce the behavior on a more vanilla kernel, I have removed the
comments about it from the TODO section of the driver. It isn't a true
kernel bug at least with a more recent stable kernel.

Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
