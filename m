Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbYDOLP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbYDOLP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbYDOLPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:15:12 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52234 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbYDOLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:15:10 -0400
Date: Tue, 15 Apr 2008 16:44:59 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, mathieu.desnoyers@polymtl.ca, hunt@redhat.com
Subject: [RFC Patch 0/1] Enhancements to 'trace' infrastructure
Message-ID: <20080415111459.GB5295@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please review the following patch which introduces two new
interfaces to output data using 'trace' infrastructure. These interfaces
can be used to print directly onto a debugfs mount. Since it uses 'trace'
interface underneath the directory and file structures are as created by
'trace'.

The proposed debugfs_* interfaces are meant to overcome the need to
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
d) The debugfs_printk_data may be further enhanced to provide features
suh as the ability to invoke pre- and post- printing callback functions
For e.g. A callback function to obtain a given lock before printing out
a given data, etc.
 
A quick look at samples/trace/fork_trace.c would help understand what is
required to get data out using the 'trace' infrastructure (vs the
proposed interfaces which have been exemplified in
samples/trace/fork_new_trace.c).

The patches are based against 2.6.25-rc8-mm1 and have been tested on an
i386 machine.

Thanks,
K.Prasad

