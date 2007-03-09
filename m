Return-Path: <linux-kernel-owner+w=401wt.eu-S2992891AbXCICfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992891AbXCICfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992892AbXCICfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:35:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59110 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992891AbXCICfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:35:08 -0500
Date: Thu, 8 Mar 2007 18:35:07 -0800
From: Paul Jackson <pj@sgi.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: vatsa@in.ibm.com, ebiederm@xmission.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org, menage@google.com
Subject: Re: [PATCH 1/2] rcfs core patch
Message-Id: <20070308183507.51454499.pj@sgi.com>
In-Reply-To: <20070309004816.GB4506@MAIL.13thfloor.at>
References: <20070301133543.GK15509@in.ibm.com>
	<20070301134528.GL15509@in.ibm.com>
	<m1slcg8m4f.fsf@ebiederm.dsl.xmission.com>
	<20070308101347.GA29051@in.ibm.com>
	<20070309004816.GB4506@MAIL.13thfloor.at>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert wrote:
> why is the filesystem approach so favored for this
> kind of manipulations?

I don't have any clear sense of whether the additional uses of file
systems being considered here are a good idea or not, but the use of a
file system for cpusets has turned out quite well, in my (vain and
biased ;) view.

Cpusets are subsets of the CPUs and memory nodes on a system.

These subsets naturally form a partial ordering, where one cpuset is
below another if its CPUs and nodes are a subset of the other ones.

This forms a natural hierarchical space.  It is quite convenient to be
able to add names and file system like attributes, so that one can do
things like -name- the set of CPUs to which you are attaching a job, as
in "this job is to run on the CPUs in cpuset /foo/bar", and to further
have file system like permissions on these subsets, to control who can
access or modify them.

For such hierarchical data structures, especially ones where names and
permissions are useful, file systems are a more natural interface than
traditional system call usage patterns.

The key, in my view, is the 'shape' of the data.  If the data schema is
basically a single table, with uniform rows having a few fields each,
where each field is a simple integer or string (not a fancy formatted
string encoding some more elaborate shape) then classic system call
patterns work well.  If the schema is tree shaped, and especially if
the usual file system attributes such as a hierarchical name space and
permissions are useful, then a file system based API is probably best.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
