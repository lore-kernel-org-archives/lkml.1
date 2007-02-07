Return-Path: <linux-kernel-owner+w=401wt.eu-S1161374AbXBGQeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161374AbXBGQeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161375AbXBGQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:34:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:45057 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161374AbXBGQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dmtfymlz9XpKNbcbvyEG4e0bVGvVEVgnh1s5ZsCIt4sWFhtQkLlOu9nzaO+YruMmZ85STl4D7PmN4phSBFYmLWfBSKfVBb99g8D35gjES8QxnPLH8B7kDHcYNIBMO2NVTfCQ9ETZghCPVCT40ZqNc3S5wFbCCDHikFtbX+SjSp8=
Message-ID: <619420780702070834n6dec9871keb87bf913a2ca5@mail.gmail.com>
Date: Wed, 7 Feb 2007 17:34:20 +0100
From: "Jack Bauer" <mlsubscriber@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [QUESTION] Kernelspace <-> Userspace communication during tcp stack code execution
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm a student in computer science and for my master thesis i have to
modify the kernel TCP stack in a way that it allows to perform a
transparent user authentification during the TCP 3-way-handshake (with
the help of a modified firewall which tracks the 3-way-handshake).

As you might imagine I have to alter the syn,synack and ack packets
and fill it with authentification information of the user who
initiated the new TCP connection. These information are stored in
config files on the client/user host (for example a config file which
contains the location of the users certificate). On the firewall host
I also need file access from within a netfilter kernel module and have
to perform other time consuming tasks (for example reading the root
certificate and check the users cert in the syn packet).

As these tasks are typical userspace tasks I want to write a daemon
which does all the file access and certificate work when the kernel
requests it and which than sends the information back to the kernel.

What opportunities do I have to implement a fast Kernel <-> Userspace
Daemon communication?

My first tought was to create a /proc or /dev entry and register file
operation functions for these entries. But the first problem I see is
that the daemon has to read the /proc or /dev file in an endless loop
so that the daemon recognizes (in a fast way) when the kernel pushes
request commands to the /proc or /dev file. The second problem is that
the kernel has to wait for the answer of the daemon before it can
continue and putting the requested information in the syn packet for
example. And what happens if the request method (which got called in
the tcp stack) blocks until the daemon response was read in? I think
the kernel would hang, wouldn't it?

The second tought was to use AF_NETLINK which should solve the first
problem but as the NETLINK readmsg() method also blocks until it
recieved data I don't know if the kernel would also hang.

Do you have any suggestions how to solve this situation?

regards,
Jack
