Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZK0WlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZK0WlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZK0WlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:41:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34250 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZK0WlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:41:18 -0500
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       paul Mackerras <paulus@samba.org>, gregkh@suse.de
References: <4B0CD70F.6090600@austin.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 27 Nov 2009 14:41:15 -0800
In-Reply-To: <4B0CD70F.6090600@austin.ibm.com> (Nathan Fontenot's message of "Wed\, 25 Nov 2009 01\:04\:47 -0600")
Message-ID: <m13a3ztwtw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Nathan Fontenot <nfont@austin.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.2 SUBJECT_FUZZY_TION Attempt to obfuscate words in Subject:
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v2 0/3] Kernel handling of Dynamic Logical Partitioning
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot <nfont@austin.ibm.com> writes:

> version 2 of the patch set with updates from comments.
>
> The Dynamic Logical Partitioning (DLPAR) capabilities of the powerpc pseries
> platform allows for the addition and removal of resources (i.e. cpus,
> memory, pci devices) from a partition. The removal of a resource involves
> removing the resource's node from the device tree and then returning the
> resource to firmware via the rtas set-indicator call.  To add a resource, it
> is first obtained from firmware via the rtas set-indicator call and then a
> new device tree node is created using the ibm,configure-coinnector rtas call
> and added to the device tree.
>
> The following set of patches implements the needed infrastructure to have the
> kernel handle the DLPAR addition and removal of cpus (other DLPAR'able items to
> follow in future patches).  The framework for this is to create a set of
> probe/release sysfs files that will facilitate arch-specific call-outs to handle
> addition and removal of cpus to the system.

How does this differ from /sys/devices/system/cpu/cpuX/online ?

>From the descriptions it appears that we already have what you are trying to
add and you just need to tie it into DLPAR on ppc.

Eric
