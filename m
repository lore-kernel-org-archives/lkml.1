Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYBRJ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYBRJ5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYBRJ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:56:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYBRJ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:56:55 -0500
Message-ID: <47B9560F.3030402@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 17:55:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Paul Menage <menage@google.com>, balbir@in.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, vatsa@linux.vnet.ibm.com,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup structured
 file API
References: <20080215204418.535025000@menage.corp.google.com>	<20080215204821.778088000@menage.corp.google.com> <20080216212901.70fe35ce.pj@sgi.com>
In-Reply-To: <20080216212901.70fe35ce.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Ok ... this would (I suspect, just from code reading, no bytes were
> harmed in actual testing of this) have a minor change to how white
> space is handled writing integer flags to cpuset files, and a minor
> inconstency.
> 
>  1) Existing cpuset code lets you set a flag (e.g. cpu_exclusive) by doing:
> 	echo '1 rumplestiltskin' > cpu_exclusive   # same as: echo 1 > cpu_exclusive
>     With this patch, that probably fails, EINVAL.
> 
>  2) With this patch, one can write "1" or "1\n" to cpuset integer files, but one
>     cannot successfully write "1\r\n" or "1 " or "1 \n".  However, for the cpuset
>     control files that take strings, not single integers, one -can- have any mix
>     of trailing white space.
> 
> So far as I know, I have no requirement to write rumplestiltskin to cpuset files ;).
> So I'm content to let the minor change in (1) pass without further comment.
> 
> I'd like to recommend consideration of the following patch, to address the
> minor inconsistency of (2), and to save a few bytes of kernel text space.
> 

For memory controller, we have to do this:
	echo -n 4m > memory.limit_in_bytes
'-n' is necessary. This is another inconsistency..
