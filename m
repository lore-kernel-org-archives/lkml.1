Return-Path: <linux-kernel-owner+w=401wt.eu-S1763588AbXLREsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763588AbXLREsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbXLREsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:48:42 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:26652 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753402AbXLREsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nuObdAIcdlcNrW2xFvASIjEM6ZCxk1ufbPLkDAr9llF1BkI+EB/4QLaaQvstyOAfZHd5DADgC2jyM/WdrgQW4TqhTi+YYurlxWjcmvljF/F5RCZyRDlRAvV7eSFrpq9xGakJ8WoajiRRcBXfCanM2uPVTegdAmxs0RprqJeSlr8=
Message-ID: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
Date: Mon, 17 Dec 2007 20:48:40 -0800
From: "Bret Towe" <magnade@gmail.com>
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: xfs mknod regression
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hit a bug in 2.6.24-rc looks to be in 2.6.23 also so not sure how
long it's been there
with an xfs filesystem pbuilder has an issue using device files it
makes for chroot
the mknod command looks to work fine the file is created
however when attempting to use one of the created files you see
something like the below

ghoststar dev # echo "hi" > null
bash: null: No such device or address
ghoststar dev # ls -l null
crw-rw-rw- 1 root root 1, 3 2007-12-17 20:34 null
ghoststar dev # ls -l /dev/null
crw-rw-rw- 1 root root 1, 3 2007-10-05 17:29 /dev/null
ghoststar dev # echo "hi" > /dev/null
ghoststar dev #

I have not done any bisecting yet if needed I can narrow it down
the minor work around I found was to just mount an ext3 filesystem
where pbuilder builds
