Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYKSSNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYKSSNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYKSSMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:12:55 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:58150 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbYKSSMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:12:55 -0500
Date: Wed, 19 Nov 2008 10:12:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject: 'vcs1' (d2172ad8): kobject_add_internal: parent: 'vc',
 set: 'devices'
Message-Id: <20081119101238.c46ad0cd.randy.dunlap@oracle.com>
In-Reply-To: <20081119095934.GF4370@vanheusden.com>
References: <20081119095934.GF4370@vanheusden.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4924571C.004C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 10:59:41 +0100 Folkert van Heusden wrote:

> Hi,
> 
> What switch is responsible for this logging:
> [   94.025172] kobject: 'vcsa1': free name
> [   94.025231] kobject: 'vcs1' (d2172ad8): kobject_add_internal: parent: 'vc', set: 'devices'
> [   94.025308] kobject: 'vcs1' (d2172ad8): kobject_uevent_env
> [   94.025315] kobject: 'vcs1' (d2172ad8): fill_kobj_path: path = '/class/vc/vcs1'
> [   94.025352] kobject: 'vcsa1' (d23f00d8): kobject_add_internal: parent: 'vc', set: 'devices'
> [   94.025398] kobject: 'vcsa1' (d23f00d8): kobject_uevent_env
> 
> I can't find it and it removes an oops from dmesg before i can capture it.

Those prints use pr_debug() from include/linux/kernel.h, which was changed
most recently in

commit d091c2f58ba32029495a933b721e8e02fbd12caa
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Wed Nov 12 21:16:43 2008 +0100

    Add 'pr_fmt()' format modifier to pr_xyz macros.

Do you have CONFIG_DYNAMIC_PRINTK_DEBUG enabled?  That could affect the
kernel log output.

---
~Randy
