Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbXLCJ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbXLCJ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXLCJ0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:26:21 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:8360 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXLCJ0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:26:20 -0500
Date: Mon, 3 Dec 2007 12:26:07 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: gregkh@suse.de, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: kobject ->k_name memory leak
Message-ID: <20071203092607.GA22477@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg!

Commit ce2c9cb0259acd2aed184499ebe41ab00da13b25 aka
"kobject: remove the static array for the name" introduced memory leak
of a module name after modprobe/rmmod. Apparently for modules ->release
callback is NULL.

kobject_cleanup: ->release = 00000000, name = 'foo_sysctl'
Pid: 1927, comm: rmmod Not tainted 2.6.24-rc3-e1cca7e8d484390169777b423a7fe46c7021fec1 #5
 [<c10d4a58>] kobject_cleanup+0xb8/0xc0
 [<c10d4a60>] kobject_release+0x0/0x10
 [<c10d587b>] kref_put+0x2b/0xa0
 [<c11dbe85>] _spin_unlock+0x25/0x40
 [<c1045b78>] free_module+0x78/0xd0
 [<c104773f>] sys_delete_module+0x12f/0x1a0

