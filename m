Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbZKXCXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbZKXCXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZKXCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:23:51 -0500
Received: from doppler.zen.co.uk ([212.23.3.27]:57479 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZKXCXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:23:50 -0500
Message-ID: <4B0B4362.1020809@csr.com>
Date: Tue, 24 Nov 2009 02:22:26 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Roel Kluin <roel.kluin@gmail.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <4B0836A2.1000805@gmail.com> <20091123163745.60c719c7.akpm@linux-foundation.org>
In-Reply-To: <20091123163745.60c719c7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: david.vrabel@csr.com
Subject: Re: [PATCH] wusb: Use sizeof struct rather than pointer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on localhost)
X-Originating-Smarthost03-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> But I wonder if the code will still work.  Because we then go on to do
> 
>         secd_size = le16_to_cpu(secd->wTotalLength);
>         secd = krealloc(secd, secd_size, GFP_KERNEL);
> 
> which implies (to me) that the thing we read from the device might
> indeed have been smaller than we expected, in which case the
> newly-fixed check will cause a failure.

We first read the security descriptor which tells use the total length 
of the security descriptor plus all the following encryption type 
descriptors.  Your revised patch is fine.

David
