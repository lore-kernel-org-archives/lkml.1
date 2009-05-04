Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZEDPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZEDPe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZEDPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:34:46 -0400
Received: from mx32b01.es6.egwn.net ([195.10.6.123]:43547 "EHLO
	mx1.es6.egwn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZEDPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:34:45 -0400
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 11:34:45 EDT
Date: Mon, 4 May 2009 17:14:08 +0200
From: Matthias Saou 
	<thias@spam.spam.spam.spam.spam.spam.spam.egg.and.spam.freshrpms.net>
To: linux-kernel@vger.kernel.org
Subject: Wrong network usage reported by /proc
Message-ID: <20090504171408.3e13822c@python3.es.egwn.lan>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm posting here as a last resort. I've got lots of heavily used RHEL5
servers (2.6.18 based) that are reporting all sorts of impossible
network usage values through /proc, leading to unrealistic snmp/cacti
graphs where the outgoing bandwidth used it higher than the physical
interface's maximum speed.

For some details and a test script which compares values from /proc
with values from tcpdump :
https://bugzilla.redhat.com/show_bug.cgi?id=489541

The values collected using tcpdump always seem realistic and match the
values seen on the remote network equipments. So my obvious conclusion
(but possibly wrong given my limited knowledge) is that something is
wrong in the kernel, since it's the one exposing the /proc interface.

I've reproduced what seems to be the same problem on recent kernels,
including the 2.6.27.21-170.2.56.fc10.x86_64 I'm running right now. The
simple python script available here allows to see it quite easily :
https://www.redhat.com/archives/rhelv5-list/2009-February/msg00166.html

 * I run the script on my Workstation, I have an FTP server enabled
 * I download a DVD ISO from a remote workstation : The values match
 * I start ping floods from remote workstations : The values reported
   by /proc are much higher than the ones reported by tcpdump. I used
   "ping -s 500 -f myworkstation" from two remote workstations

If there's anything flawed in my debugging, I'd love to have someone
point it out to me. TIA to anyone willing to have a look.

Matthias

-- 
Clean custom Red Hat Linux rpm packages : http://freshrpms.net/
Fedora release 10 (Cambridge) - Linux kernel
2.6.27.21-170.2.56.fc10.x86_64 Load : 0.39 0.30 0.34
