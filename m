Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZGIP0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZGIP0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbZGIP00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:26:26 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:62425 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761173AbZGIP0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:26:24 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4A560363.6050304@schaufler-ca.com>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A554B95.6070709@schaufler-ca.com> <1247148306.4398.157.camel@localhost>
	 <4A560363.6050304@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Jul 2009 11:16:42 -0400
Message-Id: <1247152602.4398.185.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 07:49 -0700, Casey Schaufler wrote:
> 
> Smack depends on the xattr interfaces to inspect and manipulate labels
> on file system objects. Now you have a file system that "supports"
> xattrs, but not the xattr interfaces. What if I want to change the
> label on a sysfs entry? Or even read it? I can't with your scheme.
> 
> You are proposing a one-off hack to solve a particular problem. It
> introduces issues of its own. I don't care that it is clever and
> compact. It's not right.

getfattr -d -m security.* /sys/fs/
getfattr: Removing leading '/' from absolute path names
# file: sys/fs/
security.selinux="system_u:object_r:sysfs_t:s0\000"

# ls -Z
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     block
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     bus
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     class
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     dev
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     devices
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     firmware
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     fs
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     hypervisor
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     kernel
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     module
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     power

# setfattr -n security.selinux -v "system_u:object_r:usr_t:s0
\000" /sys/fs/

# ls -Z
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     block
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     bus
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     class
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     dev
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     devices
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     firmware
drwxr-xr-x  root root system_u:object_r:usr_t:s0       fs
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     hypervisor
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     kernel
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     module
drwxr-xr-x  root root system_u:object_r:sysfs_t:s0     power

Now you can argue that it doesn't have the user.* name space or other
name spaces but a file system doesn't have to implement every xattr name
space. We are only implementing the security name space here and your
objection of the xattr interface not being maintained doesn't hold. If
someone wants to go through and do generic xattr support for
non-persistent file systems I welcome that but it's unclear to me what
use case supports that kind of memory usage.

