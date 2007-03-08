Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXCHNFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXCHNFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 08:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXCHNFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 08:05:06 -0500
Received: from ns.suse.de ([195.135.220.2]:50985 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXCHNFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 08:05:04 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: refcounting drivers' data structures used in sysfs buffers
Date: Thu, 8 Mar 2007 14:05:00 +0100
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081405.01087.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after a lightning bolt from high above I've been looking into refcounting
the data structures drivers use to provide the data used to refill sysfs
buffers. I've come to the following conclusion.

1. struct sysfs_buffer must have a struct kref * and probably a destructor
pointer
2. drivers must be able to pass these pointers through an extended
device_create_file()
3. Drivers must use refcounting if they want to use attributes
4. read/write/poll must do refcounting

I am not sure where to store the pointers. struct sysfs_dirent() looks
like the obvious choice. Comments?

	Regards
		Oliver
