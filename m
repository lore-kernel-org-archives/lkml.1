Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbYENBcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbYENBcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYENBcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:32:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYENBcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:32:08 -0400
Message-ID: <482A40C0.8030708@cn.fujitsu.com>
Date: Wed, 14 May 2008 09:30:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups control
 files
References: <20080513063707.049448000@menage.corp.google.com>	 <20080513071522.133586000@menage.corp.google.com>	 <48295E11.2000003@cn.fujitsu.com> <6599ad830805131407y3d94016cn773ba21a42b6098c@mail.gmail.com>
In-Reply-To: <6599ad830805131407y3d94016cn773ba21a42b6098c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  > @@ -1518,16 +1580,21 @@ static ssize_t cgroup_file_read(struct f
>>  >       struct cftype *cft = __d_cft(file->f_dentry);
>>  >       struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
>>  >
>>  > -     if (!cft || cgroup_is_removed(cgrp))
>>  > +     if (cgroup_is_removed(cgrp))
>>  >               return -ENODEV;
>>  >
>>
>>  This check seems redundant now.
>>
> 
> It's not needed for safety, but it doesn't seem to hurt to check
> cgroup_is_removed() prior to doing any copying, since we'll fail after
> copying anyway if cgroup_is_removed() returns true (once we've taken
> any relevant locks).
> 

It's a bit odd to me that cgroup_is_removed() is removed in cgroup_file_write(),
but it's ressered here.

