Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYAWTRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYAWTRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYAWTRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:17:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYAWTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:17:34 -0500
Message-ID: <47978F5D.8010006@zytor.com>
Date: Wed, 23 Jan 2008 11:02:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <4792DF11.7040403@zytor.com> <E1JGVSG-0003mx-TS@pomaz-ex.szeredi.hu> <20080123134926.GB4059@ucw.cz>
In-Reply-To: <20080123134926.GB4059@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2008-01-20 09:23:00, Miklos Szeredi wrote:
>>> Miklos Szeredi wrote:
>>>> - for mount ID's use IDA (from the IDR library) instead of a 32bit
>>>>   counter, which could overflow
>>> IDAs tend to get reused quickly, which can cause race conditions.  Any 
>>> reason not to just use a 64-bit counter?
>> They tend to become hard to parse/compare for humans after a while.
>> And all this is basically only for humans, so race conditions don't
>> really matter.  Also a changed mount with a reused ID is easily
>> identified by comparing the other fields.
> 
> Hmm, smart humans only compare last few digits if they don't care
> about 100% reliability, and dumb software compares 64bits easily...
> 							Pavel

Indeed.

And this is most certainly NOT only for humans, and race conditions most 
certainly matter.

	-hpa
