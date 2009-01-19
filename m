Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbZASGgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbZASGgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 01:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbZASGf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 01:35:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328AbZASGf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 01:35:58 -0500
Message-ID: <49741F14.80808@zytor.com>
Date: Sun, 18 Jan 2009 22:35:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated	task_pgrp_nr()
References: <20090118073441.GA699@redhat.com> <1232331602.3136.19.camel@zeus.themaw.net>
In-Reply-To: <1232331602.3136.19.camel@zeus.themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote:
> On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
>> parse_options(&pgid) sets pgid = task_pgrp_nr() which uses the global
>> namespace. This is wrong, we use this pgid to find "struct pid" in the
>> current's namespace. Change parse_options() to use task_pgrp_vnr().
>>
>> Also do s/task_pgrp_nr/task_pgrp_vnr/ in the debugging printks.
>> checkpatch.pl complains about "line over 80 characters", but it should
>> blame the cuurent code, not the patch.
> 
> This changelog entry doesn't really have anything that I can use to work
> out if this change might introduce regressions.
> 
> It would be helpful to me if you could include:
> 1) A brief statement about what your trying to achieve and why.
> 2) The reason why task_pgrp_nr() has changed to task_pgrp_vnr() since
> you made the change (that is someone working on pid namespaces) to
> task_pgrp_nr().
> 3) Why you believe this change won't introduce a regression.
> 

The other thing is also: isn't it high time to remove autofs 3?  It has
been unmaintained for at least 10 years now.  I should know ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

