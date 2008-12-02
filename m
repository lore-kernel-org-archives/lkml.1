Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYLBQbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYLBQbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYLBQbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:31:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:15494 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbYLBQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BU6icuKNUKvQch5iX7ry6xZEq4ymZJ3B0G37kXuknG3KiE3Hh6MzmQeW956XhBEXHh
         DMWvckQn98zFF0zm6WfTsSPS43HsmPtN9YoK7V68mxbnYR6zt7h+GrnBx4D1kcP7gHX6
         r8dZGqB15TIB6JaKsTfnVZyL9W97yyPXL/vM4=
Message-ID: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com>
Date: Tue, 2 Dec 2008 10:31:20 -0600
From: "Steve French" <smfrench@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Support for applications which need NFS or CIFS "share_deny" flags on open
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the Wine community posted last month to the cifs mailing list
asking about a change needed for Wine for working properly over
network mounts, but the change is not really cifs specific and would
help other file systems as well so I wanted to mention it here.   The
original post was:
http://marc.info/?l=linux-cifs-client&m=122505569315992&w=2

Support for the flags they suggest would be easy for cifs (the
protocol has a field for this, and cifs clients on various other OS
set it), and should be fairly easy for NFSv4 (the RFC for NFSv4
specifies the "share_deny" field within the NFS open request, and
various clients, but not Linux, set it), and would allow WINE to
function properly over a network mount.

>we proffer to add into the file /usr/include/asm-generic/fcntl.h
> following flags:
>
>#define O_DENYREAD      004000000 /* Do not permit read access */
>#define O_DENYWRITE     010000000 /* Do not permit write access */
>#define O_DENYDELETE  020000000 /* Do not permit delete or rename
> operations*/

Presumably for applications on local mounts, wine mediates their own
mandatory locks, but this is impossible on network mounts without this
change (and can lead to data corruption).

-- 
Thanks,

Steve
