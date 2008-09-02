Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYIBGbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYIBGbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYIBGba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:31:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54654 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYIBGb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:31:29 -0400
To: "CHADHA,VINEET" <vineet@ufl.edu>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: TLB evaluation for Linux
From: Andi Kleen <andi@firstfloor.org>
References: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu>
Date: Tue, 02 Sep 2008 08:31:28 +0200
In-Reply-To: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu> (VINEET CHADHA's message of "Tue, 2 Sep 2008 00:12:03 -0400 (EDT)")
Message-ID: <87od37vz27.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"CHADHA,VINEET" <vineet@ufl.edu> writes:

> Hi,
>
> I have been working to evaluate TLB performance for Linux O/S and
> virtualized workloads(such as Xen) in a Full system
> simulator(e.g. simics). While my evaluation is in nascent stage, I do
> notice that most of the IPIs in multi-core environments cause complete
> TLB Flush.
>
> I want to evaluate cost of TLB shootdown including re-population
> vs. each entry shootdown (invlpg). While a similar study has been done
> in other kernels (e.g. L4 kernel), I am not aware if it has been done
> for Linux O/S.
>
> Are there hooks or patches to test or evaluate TLB
> performance. Specifically, I would like to know where to make changes
> in Linux kernel to support each entry shootdown.

Linux doesn't use a threshold to distingush between range flush
and full flush in certain situations, but always does the full
flush. 

That is something that might be possible to be improved, but it was so
far always unclear how much it helps (it depends on the particular TLB
size, cost of TLB refill etc.)

-Andi

-- 
ak@linux.intel.com
