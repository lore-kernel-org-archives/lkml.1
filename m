Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbZJBNzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbZJBNzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZJBNzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:55:01 -0400
Received: from mxcampus2.tau.ac.il ([132.66.7.202]:11200 "EHLO
	mxcampus2.tau.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZJBNzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:55:01 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 09:55:00 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4DAESgxUqEQhFRYWdsb2JhbACaZxcVB7xGhCwE
X-IronPort-AV: E=Sophos;i="4.44,494,1249246800"; 
   d="scan'208";a="84585374"
Message-ID: <20091002154447.62823bfv3qntxrrj@webmail.tau.ac.il>
Date: Fri, 02 Oct 2009 15:44:47 +0200
From: tomerma1@post.tau.ac.il
To: linux-kernel@vger.kernel.org
Subject: How to tell when a gendisk has been freed?
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Im writing a block device that does asynchronous mirroring. The user  
creates a device by giving a local device and
connecting to a remote device (on the net), mirroring writes to both.

When the user is done with the device i would like to give him the  
option of deleting the device. To do that, i first
stop taking requests (i disallow opens by looking at a variable i  
allocated for that device (a custom struct)), next
wait until there are no more active make_requests, and finally i free  
everything... However, theres a problem
with open - when i free the device, the open dereferences a variable i  
allocated for that device, but i have already
freed the device.

The only safe way to free the device is when i know for sure no more  
opens or make_requests can be called...
To do that i have to know when the gendisk is gone (even if i  
del_gendisk it, and wait until the opener counter drops to
zero, i cant be sure that another open isnt being executed at the moment)...
However, i didnt see any way to do it, so i was wondering what is the  
right way to do it?

Thanks,
      Tomer

