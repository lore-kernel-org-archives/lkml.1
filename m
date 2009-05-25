Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZEYOxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZEYOxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZEYOxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:53:16 -0400
Received: from honeydew.cs.uni-dortmund.de ([129.217.4.43]:46852 "EHLO
	honeydew.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbZEYOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:53:15 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 10:53:15 EDT
Date: Mon, 25 May 2009 16:44:57 +0200
From: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Subject: chmod fails though it pretends to succeed
Message-Id: <20090525164457.278f0ec0.Christoph.Pleger@cs.tu-dortmund.de>
Organization: Technische Universitaet Dortmund
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.6.10; sparc-sun-solaris2.10)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a strange problem here with a C program that calls chmod.

The C program is a PAM module called pam-devperm. The purpose of this
module is to set appropriate device ownerships and permissions when a
user logs in. But the module does not work as expected on my Ubuntu
9.04 system. When a user logs in the first time after system boot, only
the device ownerships are changed, the permissions are not. When the
user logs out and in again, permissions are changed, too.

I added some lines of code to the the source of of pam-devperm so that
it produces more debug output when changing the properties of /dev/dsp.
The debug output showed me that chmod has been called to set the
permissions of /dev/dsp to 0600 and that chmod returned 0, which means
success. In spite of that, device permissions remain at 660.

Now I have two questions:

1. What can be the reason for chmod to return a value of 0 though
device permissions have not been changed?

2. What can be the reason why this chmod fails on the first login of a
user, but succeeds on further logins?

Regards
  Christoph  
