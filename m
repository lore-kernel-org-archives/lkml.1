Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYCCRiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYCCRiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYCCR2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:28:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:14265 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762584AbYCCR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VYg8drE/aphS7w8VLvYld63dm72u9y/oOXfXMaVmKF4YTjt2WTNvRdSlyqCVNTCUPuKF5liYNCL0JZZamuKMFECfUDbDVJZCSMRmGWjySW5lqE70MvLOftNcTvJ7LnoGtMiNlCx8l8foEHZObcqyqNLfasE3G1LhSH6cn5aT2ps=
Message-ID: <59ad55d30803030928t47ab84ebs1f37434d6558b72e@mail.gmail.com>
Date: Mon, 3 Mar 2008 12:28:38 -0500
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47CC2C95.1050205@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>
	 <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>
	 <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>
	 <47CC2C95.1050205@s5r6.in-berlin.de>
X-Google-Sender-Auth: 864bc251045532eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 11:51 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
...
>  Maybe I should rather use fw-device.c::idr_rwsem instead of device.sem,
>  to have better control over who takes the mutex when.  Could also be a
>  new dedicated mutex but we don't want to end up with too many of them...
>  Do you have an opinion?

Using the struct device mutex is fine, and it parallelizes better than
the global idr_mutex (FWIW).  The only concern I have there is that
the device core structs seem to change now and then, and it's not
clear what is implementation details and what is exported for drivers
to use (eg the subsystem sem).

cheers,
Kristian
