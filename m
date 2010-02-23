Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0BWHAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:00:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:24540 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0BWHAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=YMzAZtNLZDhR3BaEOAfS1jNEmemsHGg7M86yuv2XqbI2VXwqkYut2XU73GG29j+Cdd
         LBQ18dVajZ/56y8Km1nMt5t8pHB9b7QumYfcmDnBg5UGjZkL9O/QgH5mZN9H7MXP29Uk
         hQgsXKuzWpGWbheiEIaQdMhWqZy9vlMVe1H50=
Date: Tue, 23 Feb 2010 07:59:53 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: viresh kumar <viresh.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: QUERY: Inclusion of header files in kernel header files
Message-ID: <20100223065953.GB32503@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	viresh kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: viresh kumar <viresh.linux@gmail.com>
Date: Tue, Feb 23, 2010 at 12:13:35PM +0530

Hi,

> I have been through many kernel header files and have found that kernel header
> files at many places don't include other header files which they have
> dependency upon.
> 
> For example:
> <linux/amba/bus.h> uses struct device and struct resource and it doesn't
> include <linux/device.h> and <linux/resource.h> header files.
> 
> Now, whenever i try to include bus.h, i have to include device.h and resource.h.
> 
> Is this correct approach?
> 
> Again, if i include device.h and resource.h, they must be included before bus.h.

and this is the thing: all those other files which include
<linux/amba/bus.h> either include <linux/device.h> and
<linux/resource.h> directly or the last are being included indirectly
through other headers.

Baseline, struct device and struct resource's definitions have to be
available before <linux/amba/bus.h> is included. That's why you have to
include the bus.h header last.

> Now this will disturb the alphabetical ordering of including header files
> sometimes. (not in this example)

I don't think there's such thing as alphabetical header ordering and if
it were it would be rather dumb thing to do.

Hope this helps.

-- 
Regards/Gruss,
    Boris.
