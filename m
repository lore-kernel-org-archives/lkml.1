Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbYDNPtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbYDNPtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYDNPto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:49:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46629 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYDNPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:49:43 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [ANNOUNCE] seekwatcher v0.11
Date: Mon, 14 Apr 2008 11:49:34 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141149.34556.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

seekwatcher uses blktrace data to create IO graphs and movies.  I mainly use 
it to compare and tune filesystems under different workloads.

The main update in v0.11 is the ability to run blktrace for multiple block 
devices.  I'm using this for the btrfs multi-device code, but it can also 
help figure out what lvm/md are doing to the underling block devices.

Example:

seekwatcher -t dd.trace -d /dev/sda1 -d /dev/sdb1 -o dd.png \
	-p 'dd if=/dev/zero of=/mnt/file bs=1M count=4000'

Leads to something like this (the png below was 4 devices):

http://oss.oracle.com/~mason/seekwatcher/btrfs-raid0.png

It does a simple concatenation of the block numbers it finds in the blktrace 
output, and sorts the traces from all the devices by time.

Other examples and download information are available here:

http://oss.oracle.com/~mason/seekwatcher/

-chris
