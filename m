Return-Path: <linux-kernel-owner+w=401wt.eu-S1750900AbXCFUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbXCFUVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbXCFUVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:21:24 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:37521 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXCFUVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:21:23 -0500
Message-ID: <45EDCD35.80301@simon.arlott.org.uk>
Date: Tue, 06 Mar 2007 20:21:09 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Harald Welte <laforge@gnumonks.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix buffer overflow in Omnikey CardMan 4040 driver
References: <1173215520.15106.9.camel@aeonflux.holtmann.net>
In-Reply-To: <1173215520.15106.9.camel@aeonflux.holtmann.net>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/07 21:12, Marcel Holtmann wrote:
> Hi Linus,
> 
> the attached patch fixes a buffer overflow in the Omnikey CardMan 4040
> driver that could lead to a potential arbitrary code execution with
> kernel privileges.
> 
> Regards
> 
> Marcel
> 

-	if (count < 5) {
+	if ((count < 5) || (count > READ_WRITE_BUFFER_SIZE)) {
 		DEBUGP(2, dev, "<- cm4040_write buffersize=%Zd < 5\n", count);
 		return -EIO;
 	}

That debug message needs to be changed too since count won't always 
be < 5 when it's used.

-- 
Simon Arlott
