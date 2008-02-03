Return-Path: <linux-kernel-owner+w=401wt.eu-S935893AbYBCIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935893AbYBCIpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 03:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbYBCIpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 03:45:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:43061 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567AbYBCIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 03:45:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tknjCpEOXLa+AHHqWNN3BOVl62fYZjFyIsAG01YFjJo993TYF7evpe4eCMkSNTk0Py/GNswi/6vpUzTG3DvM2ahFM5wZ3vLuEiqD6DcWigSwMhonGgqyG4M/ux05Kfo+j6gCShoWBq1qws80bjYRfrbFgRjhn4NCcgOaa7sS/7g=
Message-ID: <47A57F25.5070902@gmail.com>
Date: Sun, 03 Feb 2008 09:45:25 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] Split list.h and move rcu-protected lists into rculist.h
References: <478FBEA0.9090203@gmail.com>	<478FBEEA.6040000@gmail.com>	<20080201155826.a2d308c1.akpm@linux-foundation.org>	<47A470F9.9060708@gmail.com> <20080202111516.5cbd0880.akpm@linux-foundation.org>
In-Reply-To: <20080202111516.5cbd0880.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 02 Feb 2008 14:32:41 +0100 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
>> Do you think it's better ?
> 
> Could.  I'd suggest that you redo the header-file split patch around the
> 2.6.25-rc1 timeframe, test it carefully then let's get it in then.
> 

Does the mm tree also have a calm down period during release candidates ?

I have modified the patchset so now if rcu helpers are used from
rculist.h then fine otherwise gcc warns you that you're using the
helpers from list.h like this:

init/foo.c:13: warning: ‘__deprecated_list_add_rcu’ is deprecated (declared at include/linux/rculist.h:76)

But the build process doesn't fail anymore.

For that I added some ugly hacks in list.h and rculist.h but they
definitively should be removed for mainline inclusion. I'm sending them
in response to this email.

If we include this now, then people can have a chance to notice that
rculist.h exists and fix their stuffs until 2.6.25 release
candidates but I'll redo the patchset and give it some test around the
2.6.25-rc1 timeframe anyway.

		Franck




