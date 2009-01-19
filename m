Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZASIHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZASIHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZASIG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:06:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34369 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZASIG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:06:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49743444.8070206@s5r6.in-berlin.de>
Date: Mon, 19 Jan 2009 09:05:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: righi.andrea@gmail.com
CC: Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbmem: fix copy_from/to_user() with mutex held
References: <20090117231925.GA28055@redhat.com> <20090118020038.GA17489@cmpxchg.org> <49738E4B.1030200@gmail.com> <497432B0.1080201@s5r6.in-berlin.de>
In-Reply-To: <497432B0.1080201@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Andrea Righi wrote:
>> +struct fb_info *get_fb_info(struct fb_info *info)
>> +__acquires(&info->lock)
>> +{
>> +	mutex_lock(&info->lock);
>> +	if (!info->fbops) {
>> +		mutex_unlock(&info->lock);
>> +		return NULL;
>> +	}
>> +	return info;
>> +}
>> +
>> +void put_fb_info(struct fb_info *info)
>> +__releases(&info->lock)
>> +{
>> +	mutex_unlock(&info->lock);
>> +}
>> +
> 
> These are IMO bad function names.

PS:  The return value of the mutex_lock wrapper is also bad.  A bool or
int would IMO be clearer, similar to the return value of mutex_trylock.
-- 
Stefan Richter
-=====-==--= ---= =--==
http://arcgraph.de/sr/
