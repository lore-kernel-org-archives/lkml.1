Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbXCZORK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbXCZORK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXCZORK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:17:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38166 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXCZORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:17:08 -0400
Subject: Re: [patch 1/2] hugetlb: add resv argument to hugetlb_file_setup
From: Adam Litke <agl@us.ibm.com>
To: Ken Chen <kenchen@google.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
References: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 09:17:04 -0500
Message-Id: <1174918625.21684.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 15:42 -0700, Ken Chen wrote:
> rename hugetlb_zero_setup() to hugetlb_file_setup() to better match
> function name convention like shmem implementation.  Also add an
> argument to the function to indicate whether file setup should reserve
> hugetlb page upfront or not.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

This patch doesn't really look bad at all, but...

I am worried that what might seem nice and clean right now will slowly
get worse.  This implements an interface on top of another interface
(char device on top of a filesystem).  What is the next hugetlbfs
function that will need a boolean switch to handle a character device
special case?

Am I just worrying too much here?  Although my pagetable_operations
patches aren't the most popular right now, they do have at least one
advantage IMO: they enable side-by-side implementation of the interfaces
as opposed to stacking them.  Keeping them separate removes the need for
if ((vm_flags & VM_HUGETLB) && (is_hugetlbfs_chardev())) checking. 

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

