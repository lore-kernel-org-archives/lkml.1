Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXHPGs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXHPGs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXHPGsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:48:19 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:18125 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbXHPGsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:48:18 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 02:48:18 EDT
From: Frans Pop <elendil@planet.nl>
To: ebiederm@xmission.com
Subject: Regression in 'tty layer struct pid conversions' (2.6.21)?
Date: Thu, 16 Aug 2007 08:32:01 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708160832.01369.elendil@planet.nl>
X-OriginalArrivalTime: 16 Aug 2007 06:32:01.0635 (UTC) FILETIME=[2771EB30:01C7DFCF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

Since 2.6.21, the KDE 'fish' protocol (basically remote file system access 
using ssh) has started showing problems, mostly on systems running x86_64 
kernels. The process crashes with a signal 29.

The bug log indicated a relation with the kernel. A git-bisect has shown the 
cause to be the activation patch in the 'tty layer struct pid conversions' 
patch set:
commit ab521dc0f8e117fd808d3e425216864d60390500 
Author: Eric W. Biederman <ebiederm@xmission.com> 
Date:   Mon Feb 12 00:53:00 2007 -0800 
     [PATCH] tty: update the tty layer to work with struct pid 
 
It looks from the description of the patch set that it should cause no 
changes in behavior. It may of course be that the change in the kernel has 
exposed a latent issue in the KDE code.

Details about the issue are available in the KDE BTS:
http://bugs.kde.org/show_bug.cgi?id=145123

The comments in that report indicate that the issue is almost certainly
more related to the (relative?) speed of systems than to x86_64 as an 
architecture.

Cheers,
Frans Pop
