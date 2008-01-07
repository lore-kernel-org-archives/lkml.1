Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYAGHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYAGHXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 02:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYAGHXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 02:23:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46110 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYAGHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 02:23:05 -0500
Date: Mon, 7 Jan 2008 07:23:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, htejun@gmail.com, linux-fsdevel@vger.kernel.org,
       gregkh@suse.de
Subject: [RFC] netns / sysfs interaction
Message-ID: <20080107072301.GW27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	As much as I hate to touch either subject, let alone both at
once...  Eric, would you mind explaining what exactly do you want
sysfs to do in presense of your "namespaces"?  On the "what does user
see if we do <...>" level.

	a) what happens if I do chdir("/sys/class/net/eth42/") and then
migrate?

	b) what happens to /sys/class/net/eth0/device visibility/things
it points to/etc.?

	c) what happens to open files?  E.g. to /sys/class/net - say it,
if migration happens between two getdents(2).

	d) what happens to visibility in other parts of sysfs?  E.g. to
things like
$ ls  /sys/devices/pci0000\:00/0000\:00\:0a.0/
bus     device  local_cpus  power      resource1         uevent
class   driver  modalias    resource   subsystem_device  vendor
config  irq     net:eth0    resource0  subsystem_vendor
$
See that net:eth0 in there?  Are all such suckers seen?

	e) while we are at it, wouldn't seeing the information in
/sys/devices/pci in general defeat whatever purpose you have in mind
for your stuff?

Context: we need sane locking for sysfs.  I think I have a more or less
workable scheme, but its feasibility depends big way on what netns needs
to have.
