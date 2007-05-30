Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbXE3Fzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbXE3Fzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXE3Fzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:55:33 -0400
Received: from quest.jpl.nasa.gov ([137.79.56.36]:51123 "EHLO
	quest.jpl.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXE3Fzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:55:32 -0400
X-Greylist: delayed 1452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 01:55:32 EDT
In-Reply-To: <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com> <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk> <200705290943.11176.dhazelton@enter.net> <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <172CB60C-2F1F-4CCE-8AB7-C7CFA1161AA0@alumni.caltech.edu>
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       jloup@gzip.org
Content-Transfer-Encoding: 7bit
From: Mark Adler <madler@alumni.caltech.edu>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Tue, 29 May 2007 22:31:19 -0700
To: Satyam Sharma <satyam.sharma@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 29, 2007, at 8:15 AM, Satyam Sharma wrote:
> skipping some checksum calculation if some
> flag (PRESET_DICT) is absent from the input stream about to
> be decompressed ...

You don't need to dissect the header manually to look for that bit.   
If you feed inflate() at least the first two bytes, it will return  
immediately with the Z_NEED_DICT return code if a preset dictionary  
is requested.  You can force inflate() to return immediately after  
decoding the two byte header even if a preset dictionary is not  
requested by using the Z_BLOCK flush code.

Mark

