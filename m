Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZHOAcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZHOAcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 20:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZHOAcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 20:32:03 -0400
Received: from claw.goop.org ([74.207.240.146]:38803 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZHOAcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 20:32:02 -0400
Message-ID: <4A860200.5020407@goop.org>
Date: Fri, 14 Aug 2009 17:32:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Integrity problem when cloning git tree onto new btrfs filesystem
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a shiny new 10G btrfs filesystem on a 2.6.31-rc5 (x86-64
running as Xen domU), and tried cloning a fresh copy of linux-2.6 onto it:

    [jeremy@f11-64 git]$ git clone
    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    Initialized empty Git repository in /mnt/jeremy/git/linux-2.6/.git/
    remote: Counting objects: 1270263, done.
    remote: Compressing objects: 100% (204288/204288), done.
    Receiving objects: 100% (1270263/1270263), 313.23 MiB | 4485 KiB/s,
    done.
    remote: Total 1270263 (delta 1060042), reused 1268033 (delta 1057934)
    error: inflate: data stream error (incorrect header check)
    fatal: serious inflate inconsistency
    fatal: index-pack failed

Running the same command a second time on the same filesystem completed
successfully, as did the same command on an ext3 filesystem.  There were
no unexpected messages on the console (well, I was a bit surprised it
decided to go into SSD mode, but I guess virtual disks are marked as
being non-seeking as well).

    J

