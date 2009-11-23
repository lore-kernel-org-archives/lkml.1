Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZKWCmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZKWCmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZKWCmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:42:06 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44211 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZKWCmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:42:05 -0500
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <m11vjtrpfk.fsf@fess.ebiederm.org>
	<alpine.LRH.2.00.0911230917020.19108@tundra.namei.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 22 Nov 2009 18:42:04 -0800
In-Reply-To: <alpine.LRH.2.00.0911230917020.19108@tundra.namei.org> (James Morris's message of "Mon\, 23 Nov 2009 09\:18\:32 +1100 \(EST\)")
Message-ID: <m13a46m077.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC][PATCH] security/selinux: Simplify proc inode to security label mapping.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> writes:

> On Fri, 20 Nov 2009, Eric W. Biederman wrote:
>
>> 
>> Currently selinux has incestuous knowledge of the implementation details
>> of procfs and sysctl that it uses to get a pathname from an inode. As it
>> happens the point we care is in the security_d_instantiate lsm hook so
>> we have a valid dentry that we can use to get the entire pathname on
>> the proc filesystem.  With the recent change to sys_sysctl to go through
>> proc/sys all proc and sysctl accesses go through the vfs, which
>> means we no longer need a sysctl special case.
>
> I need to investigate this further, but one immediate issue is that 
> Tomoyo seems to have similar code.

The Tomoyo code is currently gone in the sysctl tree (and thus in
linux-next), that change was part of what got me thinking about changing
selinux as well.

If we can remove the selinux special case as well then we can actually
remove the sysctl hook from the lsm.

Eric
