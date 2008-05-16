Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYEPRCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYEPRCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYEPRCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:02:23 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46492 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752702AbYEPRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:02:22 -0400
Date: Fri, 16 May 2008 22:31:51 +0530
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: [Patch 0/1] Enhancements to 'trace' infrastructure - v2
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: dwilder@us.ibm.com, akpm@linux-foundation.org,
       "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please review the following patch which introduces two new
interfaces to output data using 'trace' infrastructure. These interfaces
can be used to print directly onto a debugfs mount. Since it uses
'trace'
interface underneath the directory and file structures are as created by
'trace'.

The proposed trace_* interfaces are meant to overcome the need to
setup/tear-down 'trace' infrastructure by the user. In addition to this
the patches help in:

a) Printing out data into a debugfs mounted file without bothering about
creating/re-using debugfs files, sizes of intermediate buffers, etc.
(This is achieved through the functions init_trace_interface() and
trace_exists()).
b) Provide interfaces to do i)string output or ii)binary dump of data
c) Tear-down of the trace infrastructure through a single function call
using its parent directory name, and unmindful of the internal data
structures such as 'struct trace_info'.(using trace_cleanup_all)
d) The trace_printk_data may be further enhanced to provide features
suh as the ability to invoke pre- and post- printing callback functions
For e.g. A callback function to obtain a given lock before printing out
a given data, etc.

A quick look at samples/trace/fork_trace.c would help understand what is
required to get data out using the 'trace' infrastructure (vs the
proposed interfaces which have been exemplified in
samples/trace/fork_new_trace.c).

The patches are based against 2.6.25-mm1 and have been tested on an
i386 machine.

Thanks,
K.Prasad
