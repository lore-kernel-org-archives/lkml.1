Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbZKDFME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbZKDFME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 00:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZKDFME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 00:12:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZKDFMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 00:12:03 -0500
Message-ID: <4AF10CEE.5020807@cn.fujitsu.com>
Date: Wed, 04 Nov 2009 13:11:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Liu Aleaxander <aleaxander@gmail.com>
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH] cgroup: Fixes the un-paired cgroup lock problem
References: <b741c2440911031740m52f8c11dt6e57b549cc6ce465@mail.gmail.com>
In-Reply-To: <b741c2440911031740m52f8c11dt6e57b549cc6ce465@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liu Aleaxander wrote:
> From: Liu Aleaxander <Aleaxander@gmail.com>
> Date: Wed, 4 Nov 2009 09:27:06 +0800
> Subject: [PATCH] Fixes the un-paired cgroup lock problem
> 
> In cgroup_lock_live_group, it locks the cgroup by mutex_lock, while in the
> cgroup_tasks_write, it unlock it by cgroup_unlock. Even though they are
> equal, but I do think we should make it pair.
> 
> BTW, should we replace others with cgroup_lock and cgroup_unlock?
> Since we already have a wrapper one and it's meaningful.
> 

Before I read the email body, I thought there is a bug where
there is a lock without unlock or vise versa.

I agree the case here can be called "unpaired", but I'm not
convinced this patch is needed. The code is not buggy or
confusing. So the patch neither fixes a bug nor make the code
more readable.

