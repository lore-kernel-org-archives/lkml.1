Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZKRWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZKRWER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZKRWEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:04:16 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51331 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbZKRWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:04:16 -0500
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <m13a4pjjh9.fsf@fess.ebiederm.org>
	<200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp>
	<m1bpjch9hy.fsf@fess.ebiederm.org>
	<200911090012.nA90CF2i016994@www262.sakura.ne.jp>
	<m1zl6j65by.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl6j65by.fsf@fess.ebiederm.org>
Message-Id: <200911190704.CHI18293.VJOMHFtOLQSOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 19 Nov 2009 07:04:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric W. Biederman wrote:
> Tetsuo Handa writes:
> 
> > Eric W. Biederman wrote:
> >> There has been a gradual transition from the assumption that the table ends with
> >> !ctl_name to the assumption that procname == NULL.  There is no sysctl entry
> >> with a valid ctl_name without a valid procname.
> >
> > I see. Then, please add below one to your patchset.
> 
> I have been looking at this and in the sysctl tree I am now going through
> the vfs for all of the the operations on /proc/sys.  I believe that means
> we can completely remove the sysctl special case in tomoyo.  Like I have
> in the patch below.
> 
> Will that work?
> 
> Eric

If you remove sysctl(2) from kernel and let userland libraries emulate

	static int name[] = { CTL_NET, NET_IPV4, NET_IPV4_LOCAL_PORT_RANGE };
	int buffer[2] = { 0, 0 };
	int size = sizeof(buffer);
	sysctl(name, 3, buffer, &size, 0, 0);

like

	FILE *fp = fopen("/proc/sys/net/ipv4/ip_local_port_range", "r");
	int buffer[2] = { 0, 0 };
	fscanf(fp, "%u %u", &buffer[0], &buffer[1]);
	fclose(fp);

or you modify sysctl(2) to call security_dentry_open() rather than
security_sysctl(), we can completely remove the sysctl special case in tomoyo.

Regards.
