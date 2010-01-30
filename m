Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684Ab0A3U5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0A3U5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276Ab0A3U5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:57:10 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:39450 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0A3U5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HicpMZdtQ6SUdryA5KobGl+v+BUC9Z/Qd4V464A5gn9h8XpgwjApsqZUrT4WjcGzF5
         jwjYkz0hWWimRaVZjSDbq4NLzLW8rtbSK3OKVk7R4RTvsw+P/9RosrfFgke84xXyrxir
         6ZP77bT4S86StmD6Pg+pK5ZvJW5Qk0tVGrcfc=
Date: Sat, 30 Jan 2010 22:53:55 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de,
       linux-raid@vger.kernel.org, dm-devel@redhat.com, arnd@arndb.de,
       maan@systemlinux.org
Subject: 2.6.33-rc6 regression: mdadm Unknown cmd 800c0910 (RAID_VERSION)
Message-ID: <20100130205353.GA3168@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under 2.6.33-rcX (at least rc5 and rc6, didn't check earlier versions),
I started seeing these messages in dmesg (I do not see these messages on 2.6.32):

[   16.528951] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda9
[   16.529570] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda9
[   16.553175] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda7
[   16.553846] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda7
[   16.577349] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda6
[   16.577954] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda6
[   16.684570] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda5
[   16.695916] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda5
[   16.702729] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda2
[   16.702743] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda2
[   16.747168] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4) on /dev/sda1
[   16.747786] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9e4) on /dev/sda1

I am running 32 bit userspace on 64 bit kernel.

I do not observe any ill effects, possibly because I do not really use raid.

The command in question seems to be RAID_VERSION.

I have verified that reverting
aa98aa31987ad9831711ae71ea2270228ab62532
makes the errors go away.

Didn't yet bother opening a bugzilla for this, let me know if I should.

-- 
MST
